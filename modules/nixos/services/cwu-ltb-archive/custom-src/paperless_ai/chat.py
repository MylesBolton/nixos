import json
import logging
import sys

from django.db.models import QuerySet

from documents.models import Document
from paperless.config import AIConfig
from paperless_ai.client import AIClient
from paperless_ai.db import db_connection_released
from paperless_ai.indexing import build_document_node
from paperless_ai.indexing import document_id_filters
from paperless_ai.indexing import exclude_document_ids_filter
from paperless_ai.indexing import get_rag_prompt_helper
from paperless_ai.indexing import load_or_build_index
from paperless_ai.indexing import read_store
from paperless_ai.prompts.context import ChatQaPromptContext
from paperless_ai.prompts.context import ChatRefinePromptContext
from paperless_ai.prompts.render import render_prompt

logger = logging.getLogger("paperless_ai.chat")

CHAT_METADATA_DELIMITER = "\n\n__PAPERLESS_CHAT_METADATA__"
CHAT_ERROR_MESSAGE = "Sorry, something went wrong while generating a response."
CHAT_NO_CONTENT_MESSAGE = "Sorry, I couldn't find any content to answer your question."
MAX_CHAT_REFERENCES = 6
CHAT_RETRIEVER_TOP_K = 6


def _build_chat_prompt(output_language: str | None) -> str:
    return render_prompt(ChatQaPromptContext(output_language=output_language))


def _build_refine_prompt(output_language: str | None) -> str:
    return render_prompt(
        ChatRefinePromptContext(output_language=output_language),
    )


def _build_document_reference(
    document: Document,
    title: str | None = None,
) -> dict[str, int | str]:
    return {
        "id": document.pk,
        "title": title or document.title or document.filename,
    }


def _get_document_references(
    documents: QuerySet[Document],
    top_nodes: list,
) -> list[dict[str, int | str]]:
    candidate_ids: set[int] = set()
    for node in top_nodes:
        try:
            candidate_ids.add(int(node.metadata["document_id"]))
        except (KeyError, TypeError, ValueError):
            continue

    if not candidate_ids:
        return []

    allowed_documents = {doc.pk: doc for doc in documents.filter(pk__in=candidate_ids)}

    references: list[dict[str, int | str]] = []
    seen_document_ids: set[int] = set()

    for node in top_nodes:
        try:
            document_id = int(node.metadata["document_id"])
        except (KeyError, TypeError, ValueError):
            continue

        if document_id in seen_document_ids or document_id not in allowed_documents:
            continue

        seen_document_ids.add(document_id)
        document = allowed_documents[document_id]
        references.append(
            _build_document_reference(document, node.metadata.get("title")),
        )

        if len(references) >= MAX_CHAT_REFERENCES:
            break

    return references


def _format_chat_metadata_trailer(references: list[dict[str, int | str]]) -> str:
    return (
        f"{CHAT_METADATA_DELIMITER}"
        f"{json.dumps({'references': references}, separators=(',', ':'))}"
    )


def stream_chat_with_documents(
    query_str: str,
    documents: QuerySet[Document],
    *,
    unrestricted: bool = False,
    output_language: str | None = None,
):
    try:
        yield from _stream_chat_with_documents(
            query_str,
            documents,
            unrestricted=unrestricted,
            output_language=output_language,
        )
    except Exception as e:
        logger.exception("Failed to stream document chat response: %s", e)
        yield CHAT_ERROR_MESSAGE


def _stream_chat_with_documents(
    query_str: str,
    documents: QuerySet[Document],
    *,
    unrestricted: bool = False,
    output_language: str | None = None,
):
    if not documents.exists():
        yield CHAT_NO_CONTENT_MESSAGE
        return

    from llama_index.core.prompts import PromptTemplate
    from llama_index.core.query_engine import RetrieverQueryEngine
    from llama_index.core.response_synthesizers import get_response_synthesizer
    from llama_index.core.retrievers import BaseRetriever, VectorIndexRetriever
    from llama_index.core.schema import NodeWithScore

    config = AIConfig()
    if unrestricted:
        trashed_ids = Document.deleted_objects.values_list("pk", flat=True)
        filters = exclude_document_ids_filter(str(pk) for pk in trashed_ids)
    else:
        filters = document_id_filters(
            str(pk) for pk in documents.values_list("pk", flat=True)
        )

    with read_store() as store:
        index = load_or_build_index(config, store)
        base_vector_retriever = VectorIndexRetriever(
            index=index,
            similarity_top_k=CHAT_RETRIEVER_TOP_K,
            filters=filters,
        )

        # -----------------------------------------------------------------
        # HYBRID RETRIEVER (Tantivy BM25 Keyword Search + Vector Embedding)
        # -----------------------------------------------------------------
        class HybridTantivyRetriever(BaseRetriever):
            def _retrieve(self, query_bundle):
                q = query_bundle.query_str
                tantivy_nodes = []
                try:
                    import re
                    from documents.search import get_backend
                    from documents.search._backend import SearchMode
                    search_backend = get_backend()

                    matched_ids = []
                    # 1. Search for specific LTB patterns like "082.20" or "082/20"
                    ltb_matches = re.findall(r"(?:ltb)?\s*(\d{2,4}[\./]\d{2,4})", q, re.IGNORECASE)
                    for m in ltb_matches:
                        clean_dot = m.replace("/", ".")
                        clean_slash = m.replace(".", "/")
                        try:
                            sub_ids = search_backend.search_ids(
                                f'"{clean_dot}" OR "{clean_slash}"', user=None, search_mode=SearchMode.QUERY, limit=5
                            )
                            matched_ids.extend(sub_ids)
                        except Exception:
                            pass

                    # 2. Search for cleaned keywords (removing conversational stop words)
                    stopwords = {
                        "what", "is", "are", "was", "were", "discussed", "in", "regarding", "about",
                        "tell", "me", "find", "search", "show", "the", "a", "an", "of", "to", "for",
                        "with", "on", "at", "by", "from", "up", "into", "over", "after", "how", "can",
                        "please", "give", "details"
                    }
                    terms = [w for w in re.findall(r"\w+", q.lower()) if w not in stopwords]
                    if terms:
                        keyword_query = " ".join(terms)
                        try:
                            kw_ids = search_backend.search_ids(
                                keyword_query, user=None, search_mode=SearchMode.QUERY, limit=10
                            )
                        except Exception:
                            kw_ids = search_backend.search_ids(
                                keyword_query, user=None, search_mode=SearchMode.TEXT, limit=10
                            )
                        matched_ids.extend(kw_ids)

                    # Deduplicate matched_ids preserving order
                    deduped_ids = []
                    seen_ids = set()
                    for mid in matched_ids:
                        if mid not in seen_ids:
                            seen_ids.add(mid)
                            deduped_ids.append(mid)

                    if not unrestricted:
                        allowed_set = set(documents.values_list("pk", flat=True))
                        deduped_ids = [mid for mid in deduped_ids if mid in allowed_set]

                    if deduped_ids:
                        target_docs = Document.objects.filter(pk__in=deduped_ids[:3])
                        for d in target_docs:
                            nodes = build_document_node(d, chunk_size=config.llm_embedding_chunk_size)
                            for n in nodes[:2]:
                                tantivy_nodes.append(NodeWithScore(node=n, score=1.5))
                except Exception as ex:
                    logger.warning("Hybrid Tantivy search warning: %s", ex)

                vec_nodes = base_vector_retriever.retrieve(query_bundle)

                combined = []
                seen = set()
                for nws in (tantivy_nodes + vec_nodes):
                    content = nws.node.get_content()
                    chash = hash(content)
                    if chash not in seen:
                        seen.add(chash)
                        combined.append(nws)

                return combined[:CHAT_RETRIEVER_TOP_K]

        hybrid_retriever = HybridTantivyRetriever()

        with db_connection_released():
            top_nodes = hybrid_retriever.retrieve(query_str)

        if not top_nodes:
            logger.warning("No nodes found for the given documents.")
            yield CHAT_NO_CONTENT_MESSAGE
            return

        client = AIClient()
        references = _get_document_references(documents, top_nodes)

        prompt_template = PromptTemplate(template=_build_chat_prompt(output_language))
        refine_template = PromptTemplate(template=_build_refine_prompt(output_language))
        response_synthesizer = get_response_synthesizer(
            llm=client.llm,
            prompt_helper=get_rag_prompt_helper(
                chunk_size=config.llm_embedding_chunk_size,
                context_size=min(config.llm_context_size, 4096),
            ),
            text_qa_template=prompt_template,
            refine_template=refine_template,
            streaming=True,
        )
        query_engine = RetrieverQueryEngine.from_args(
            retriever=hybrid_retriever,
            llm=client.llm,
            response_synthesizer=response_synthesizer,
            streaming=True,
        )

        logger.debug("Hybrid document chat query: %s", query_str)
        with db_connection_released():
            response_stream = query_engine.query(query_str)
            for chunk in response_stream.response_gen:
                yield chunk
                sys.stdout.flush()

            if references:
                yield _format_chat_metadata_trailer(references)

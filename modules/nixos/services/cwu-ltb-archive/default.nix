{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.services.cwu-ltb-archive;
in
{
  options.custom.services.cwu-ltb-archive = with types; {
    enable = mkBoolOpt false "Whether or not to enable the automated CWU LTB archive container.";
    hostWanInterface =
      mkOpt (nullOr str) null
        "The WAN network interface on the host used for NAT routing (null for all egress interfaces).";
    hostPort = mkOpt int 8080 "The public-facing port on the host forwarded to Paperless-ngx.";
    ollamaPort = mkOpt int 11434 "The host port forwarded to Ollama in the container.";
    ollamaModels = mkOpt (listOf str) [
      "llama3.2:1b"
      "nomic-embed-text:latest"
    ] "Ollama models to automatically download on startup.";
    containerHostIp =
      mkOpt str "192.168.100.10"
        "IPv4 address assigned to the host side of the container veth link.";
    containerIp = mkOpt str "192.168.100.11" "IPv4 address assigned to the container.";
    calendar = mkOpt str "daily" "Systemd OnCalendar schedule for scraping CWU LTBs.";
  };

  config = mkIf cfg.enable {
    # -------------------------------------------------------------------------
    # HOST NETWORKING & NAT CONFIGURATION
    # -------------------------------------------------------------------------
    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = cfg.hostWanInterface;
    };

    networking.firewall.allowedTCPPorts = [
      cfg.hostPort
      cfg.ollamaPort
    ];

    # -------------------------------------------------------------------------
    # DECLARATIVE NIXOS CONTAINER
    # -------------------------------------------------------------------------
    containers.cwu-ltb-archive = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = cfg.containerHostIp;
      localAddress = cfg.containerIp;

      # Forward incoming hostPort traffic to Paperless (28981) and Ollama (11434)
      forwardPorts = [
        {
          containerPort = 28981;
          hostPort = cfg.hostPort;
          protocol = "tcp";
        }
        {
          containerPort = 11434;
          hostPort = cfg.ollamaPort;
          protocol = "tcp";
        }
      ];

      config =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          system.stateVersion = "25.05";

          networking.defaultGateway = cfg.containerHostIp;
          networking.nameservers = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          networking.useHostResolvConf = false;
          networking.firewall.allowedTCPPorts = [
            28981
            11434
          ];

          # -------------------------------------------------------------------
          # OLLAMA LLM SERVICE
          # -------------------------------------------------------------------
          services.ollama = {
            enable = true;
            host = "0.0.0.0";
            port = 11434;
            loadModels = cfg.ollamaModels;
            environmentVariables = {
              OLLAMA_KEEP_ALIVE = "24h";
              OLLAMA_NUM_PARALLEL = "1";
            };
          };

          environment.systemPackages = [ pkgs.ollama ];

          # -------------------------------------------------------------------
          # PAPERLESS-NGX BACKEND
          # -------------------------------------------------------------------
          services.paperless = {
            enable = true;
            address = "0.0.0.0";
            port = 28981;
            consumptionDir = "/var/lib/paperless/consume";
            consumptionDirIsPublic = false;

            settings = {
              PAPERLESS_ALLOWED_HOSTS = "*";
              PAPERLESS_CSRF_TRUSTED_ORIGINS = "http://10.0.3.134:${toString cfg.hostPort},http://127.0.0.1:${toString cfg.hostPort},http://localhost:${toString cfg.hostPort}";

              # Paperless AI / LLM configuration
              PAPERLESS_AI_ENABLED = true;
              PAPERLESS_AI_LLM_BACKEND = "ollama";
              PAPERLESS_AI_LLM_ENDPOINT = "http://127.0.0.1:11434";
              PAPERLESS_AI_LLM_MODEL = "llama3.2:1b";
              PAPERLESS_AI_LLM_EMBEDDING_BACKEND = "ollama";
              PAPERLESS_AI_LLM_EMBEDDING_ENDPOINT = "http://127.0.0.1:11434";
              PAPERLESS_AI_LLM_EMBEDDING_MODEL = "nomic-embed-text:latest";

              # OCR configuration
              PAPERLESS_OCR_LANGUAGE = "eng";
              PAPERLESS_OCR_USER_ARGS = builtins.toJSON {
                invalidate_digital_signatures = true;
              };

              # Inotify polling fallback inside containers
              PAPERLESS_CONSUMER_POLLING = 60;
            };
          };

          # Ensure Paperless starts after Ollama
          systemd.services.paperless-web.after = [ "ollama.service" ];
          systemd.services.paperless-task-queue.after = [ "ollama.service" ];
          systemd.services.paperless-consumer.after = [ "ollama.service" ];

          # -------------------------------------------------------------------
          # AUTOMATED LTB DOWNLOADER (SYSTEMD SERVICE & TIMER)
          # -------------------------------------------------------------------
          systemd.services.cwu-ltb-downloader = {
            description = "CWU Letters to Branches (LTB) Scraper and PDF Downloader";
            after = [
              "network-online.target"
              "paperless-consumer.service"
            ];
            wants = [ "network-online.target" ];

            serviceConfig = {
              Type = "oneshot";
              User = config.services.paperless.user;
              Group = config.services.paperless.group;
              StateDirectory = "cwu-ltb-downloader";
              WorkingDirectory = "/var/lib/cwu-ltb-downloader";

              # Hardening
              ProtectSystem = "strict";
              ProtectHome = true;
              PrivateTmp = true;
              ReadWritePaths = [
                "/var/lib/cwu-ltb-downloader"
                config.services.paperless.consumptionDir
              ];
            };

            path = with pkgs; [
              bash
              curl
              file
              coreutils
              gnugrep
              gnused
              python3
            ];

            script = ''
                            set -euo pipefail

                            CONSUME_DIR="${config.services.paperless.consumptionDir}"
                            STATE_DIR="/var/lib/cwu-ltb-downloader"
                            STATE_FILE="$STATE_DIR/processed_urls.txt"
                            TEMP_DIR="$STATE_DIR/tmp"
                            USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) CWU-LTB-Archiver/1.0"
                            SITEMAP_INDEX="https://www.cwu.org/wp-sitemap.xml"

                            mkdir -p "$TEMP_DIR" "$CONSUME_DIR"
                            touch "$STATE_FILE"

                            trap 'rm -rf "$TEMP_DIR"/*' EXIT

                            log() {
                              echo "[$(date -Is)] $*"
                            }

                            log "Starting CWU LTB scraper job..."

                            # 1. Fetch main WordPress sitemap index
                            log "Fetching sitemap index from $SITEMAP_INDEX..."
                            INDEX_XML=$(curl -fsSL -A "$USER_AGENT" --max-time 30 "$SITEMAP_INDEX" || true)

                            if [[ -z "$INDEX_XML" ]]; then
                              log "ERROR: Failed to retrieve sitemap index from CWU. Exiting."
                              exit 1
                            fi

                            # Extract all LTB sitemaps in reverse version order (e.g. ltb-3.xml, ltb-2.xml, ltb-1.xml)
                            LTB_SITEMAPS=$(echo "$INDEX_XML" | grep -o 'https://www.cwu.org/wp-sitemap-posts-ltb-[0-9]\+\.xml' | sort -V -r | sort -u || true)

                            if [[ -z "$LTB_SITEMAPS" ]]; then
                              log "WARNING: No LTB sub-sitemaps found in index."
                              exit 0
                            fi

                            NEW_DOCS_COUNT=0

                            # 2. Iterate through LTB sub-sitemaps
                            for SITEMAP_URL in $LTB_SITEMAPS; do
                              log "Processing sitemap: $SITEMAP_URL"
                              SITEMAP_CONTENT=$(curl -fsSL -A "$USER_AGENT" --max-time 45 "$SITEMAP_URL" || true)

                              if [[ -z "$SITEMAP_CONTENT" ]]; then
                                log "WARNING: Unable to download $SITEMAP_URL, skipping."
                                continue
                              fi

                              # Extract individual LTB post URLs
                              POST_URLS=$(echo "$SITEMAP_CONTENT" | grep -oE "https://www.cwu.org/ltb/[^<\"'[:space:]]+" | sort -u || true)

                              for POST_URL in $POST_URLS; do
                                # Skip if post has already been archived
                                if grep -Fxq "$POST_URL" "$STATE_FILE"; then
                                  continue
                                fi

                                log "Discovered new LTB post: $POST_URL"

                                # Fetch the post HTML
                                PAGE_HTML=$(curl -fsSL -A "$USER_AGENT" --max-time 30 "$POST_URL" || true)
                                if [[ -z "$PAGE_HTML" ]]; then
                                  log "WARNING: Failed to fetch post content for $POST_URL"
                                  continue
                                fi

                                # Extract PDF links from page HTML
                                PDF_URLS=$(echo "$PAGE_HTML" | grep -oiE "(https://www.cwu.org)?/wp-content/uploads/[^\"'<>[:space:]]+" | grep -i "\.pdf$" | sort -u || true)

                                if [[ -z "$PDF_URLS" ]]; then
                                  log "NOTICE: No PDF links found on page $POST_URL (marking as processed)."
                                  echo "$POST_URL" >> "$STATE_FILE"
                                  continue
                                fi

                                for PDF_REL_OR_FULL in $PDF_URLS; do
                                  if [[ "$PDF_REL_OR_FULL" =~ ^https?:// ]]; then
                                    PDF_URL="$PDF_REL_OR_FULL"
                                  else
                                    PDF_URL="https://www.cwu.org$PDF_REL_OR_FULL"
                                  fi

                                  # Skip if PDF was already downloaded
                                  if grep -Fxq "$PDF_URL" "$STATE_FILE"; then
                                    continue
                                  fi

                                  RAW_BASENAME="''${PDF_URL##*/}"

                                  # Decode percent-encoding and sanitize filename
                                  SAFE_FILENAME=$(python3 -c '
              import urllib.parse, sys, re
              raw = sys.argv[1].split("?")[0]
              unquoted = urllib.parse.unquote(raw)
              sanitized = re.sub(r"[^\w\-. ]", "_", unquoted).strip()
              if not sanitized.lower().endswith(".pdf"):
                  sanitized += ".pdf"
              print(sanitized)
              ' "$RAW_BASENAME")

                                  TEMP_FILE="$TEMP_DIR/$SAFE_FILENAME"
                                  DEST_FILE="$CONSUME_DIR/$SAFE_FILENAME"

                                  log "Downloading PDF: $PDF_URL -> $SAFE_FILENAME"

                                  if curl -fsSL -A "$USER_AGENT" --max-time 60 "$PDF_URL" -o "$TEMP_FILE"; then
                                    MIME_TYPE=$(file -b --mime-type "$TEMP_FILE" || echo "unknown")
                                    if [[ "$MIME_TYPE" == "application/pdf" ]] || head -c 4 "$TEMP_FILE" | grep -q '%PDF'; then
                                      # Move atomically into Paperless consume directory
                                      mv -f "$TEMP_FILE" "$DEST_FILE"
                                      chmod 0644 "$DEST_FILE"
                                      echo "$PDF_URL" >> "$STATE_FILE"
                                      NEW_DOCS_COUNT=$((NEW_DOCS_COUNT + 1))
                                      log "Successfully enqueued: $SAFE_FILENAME"
                                    else
                                      log "ERROR: $SAFE_FILENAME is not a valid PDF (MIME: $MIME_TYPE). Discarding."
                                      rm -f "$TEMP_FILE"
                                    fi
                                  else
                                    log "ERROR: Download failed for $PDF_URL"
                                    rm -f "$TEMP_FILE"
                                  fi

                                  sleep 1
                                done

                                # Mark post as processed
                                echo "$POST_URL" >> "$STATE_FILE"
                              done
                            done

                            log "Scraper run complete. Enqueued $NEW_DOCS_COUNT new LTB documents."
            '';
          };

          systemd.timers.cwu-ltb-downloader = {
            description = "Daily timer for CWU LTB Downloader";
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = cfg.calendar;
              Persistent = true;
              RandomizedDelaySec = "30m";
            };
          };
        };
    };
  };
}

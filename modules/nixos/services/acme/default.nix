{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  name = "acme";
  cfg = config.services.custom."${name}";
in
{
  imports = [ ];

  options.services.custom."${name}" = {
    enable = lib.mkEnableOption "enable ACME.";

    certName = lib.mkOption {
      type = lib.types.str;
      description = "The Name for the ACME Cert.";
    };

    mainDomain = lib.mkOption {
      type = lib.types.str;
      description = "The Main ACME domain.";
    };

    extraDomains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "A list of extra domains.";
    };

    acmeEmail = lib.mkOption {
      type = lib.types.str;
      example = "contact@example.com";
      description = "The email to be used for ACME";
    };

    acmeFile = lib.mkOption {
      type = lib.types.path;
      description = "The cred file for ACME";
    };
  };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;

      defaults = {
        email = "${acmeEmail}";
        credentialsFile = "${acmeFile}";
        dnsProvider = "cloudflare";
      };

      certs = {
        "${certName}" = {
          domain = "${mainDomain}";
          extraDomainNames = lists.naturalSort cfg.extraDomains;
        };
      };
    };
  };
}

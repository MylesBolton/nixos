{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  name = "nextcloud";
  cfg = config.services."${name}";
in
{
  options.custom.services."${name}" = with types; {
    enable = lib.mkEnableOption "a comprehensive, self-contained Nextcloud setup";

    domain = lib.mkOption {
      type = lib.types.str;
      example = "example.com";
      description = "The domain for the Nextcloud instance. (will create nextcloud.domain and whitebaord.domain)";
    };

    adminEmail = lib.mkOption {
      type = lib.types.str;
      example = "contact@example.com";
      description = "The email for the initial Nextcloud administrator account.";
    };

    adminUser = lib.mkOption {
      type = lib.types.str;
      default = "nextcloud";
      description = "The username for the initial Nextcloud administrator account.";
    };

    adminPass = lib.mkOption {
      type = lib.types.path;
      description = "The passwrod for the initial Nextcloud administrator account.";
    };

    dbPass = lib.mkOption {
      type = lib.types.path;
      description = "The password for the initial database.";
    };
  };

  config = mkIf cfg.enable {
    services.custom.acme.domains = [
      "nextcloud.${domain}"
      "onlyoffice.${domain}"
      "whiteboard.${domain}"
    ];

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "nextcloud.${domain}";
      https = true;

      configureRedis = true;

      database.createLocally = true;
      config = {
        dbtype = "pgsql";
        adminpassFile = config.age.secrets.nextcloud_admin_pass.path;
      };

      appstoreEnable = true;

      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)

          ;
      };
      extraAppsEnable = true;

      settings = {
        default_phone_region = "GB";
        mail_smtpmode = "sendmail";
        mail_sendmailmode = "pipe";
      };
    };

    services.nextcloud-whiteboard-server = {
      enable = true;
      settings.NEXTCLOUD_URL = "https://nextcloud.${domain}";
      secrets = [ "/etc/nextcloud-whiteboard-secret" ];
    };

    services.nginx.virtualHosts = {
      "nextcloud.${domain}" = {
        forceSSL = true;
        useACMEHost = "custom";
      };
      "whiteboard.${domain}" = {
        forceSSL = true;
        useACMEHost = "custom";
        locations."/" = {
          proxyPass = "http://localhost:3002";
          proxyWebsockets = true;
        };
      };
    };
  };
}

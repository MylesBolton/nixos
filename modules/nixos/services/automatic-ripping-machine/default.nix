{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.automatic-ripping-machine;

  armHome = "/home/arm";

  arm-config = pkgs.runCommand "arm.yaml" { } ''
    ${pkgs.gnused}/bin/sed \
      -e 's|WEBSERVER_PORT: 8080|WEBSERVER_PORT: ${toString cfg.port}|' \
      ${cfg.package}/opt/arm/setup/arm.yaml > $out
  '';

  abcde-config = "${cfg.package}/opt/arm/setup/.abcde.conf";

in
{
  options.services.automatic-ripping-machine = {
    enable = lib.mkEnableOption "Automatic Ripping Machine";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.custom.automatic-ripping-machine;
      defaultText = lib.literalExpression "pkgs.custom.automatic-ripping-machine";
      description = "The ARM package to use.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port for the ARM UI.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.arm = { };
    users.users.arm = {
      isSystemUser = true;
      group = "arm";
      extraGroups = [
        "cdrom"
        "video"
        "render"
        "atd"
      ];
      home = armHome;
      createHome = true;
    };

    services.atd.enable = true;

    services.udev.packages = [ cfg.package ];

    environment.etc = {
      "arm/arm.yaml".source = arm-config;
      "arm/apprise.yaml".source = "${cfg.package}/opt/arm/setup/apprise.yaml";
      "arm/abcde.conf".source = abcde-config;
    };

    systemd.services.armui = {
      description = "Automatic Ripping Machine UI";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "arm";
        Group = "arm";
        WorkingDirectory = armHome;

        ExecStart = "${cfg.package}/bin/arm-ui";
        Environment = [ "ARM_CONFIG_DIR=${armHome}/config" ];
        Restart = "always";
        RestartSec = "10s";
      };
      preStart = ''
        mkdir -p ${armHome}/db ${armHome}/logs ${armHome}/media/{raw,transcode,completed} ${armHome}/music ${armHome}/config

        if [ ! -f ${armHome}/config/arm.yaml ]; then
          cp /etc/arm/arm.yaml ${armHome}/config/arm.yaml
        fi
        if [ ! -f ${armHome}/config/apprise.yaml ]; then
          cp /etc/arm/apprise.yaml ${armHome}/config/apprise.yaml
        fi
        if [ ! -f ${armHome}/config/abcde.conf ]; then
          cp /etc/arm/abcde.conf ${armHome}/config/abcde.conf
        fi

        chown -R arm:arm ${armHome}
      '';
    };

    # This is required for makemkv
    nixpkgs.config.allowUnfree = true;

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

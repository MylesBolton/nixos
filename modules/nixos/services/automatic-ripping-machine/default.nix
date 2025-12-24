{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.automatic-ripping-machine;
  armPkg = pkgs.custom.automatic-ripping-machine;
in
{
  options.services.automatic-ripping-machine = {
    enable = mkEnableOption "Automatic Ripping Machine (ARM) service";

    user = mkOption {
      type = types.str;
      default = "arm";
      description = "User account under which ARM runs.";
    };

    group = mkOption {
      type = types.str;
      default = "cdrom";
      description = "Group account under which ARM runs (should have access to optical drives).";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/home/arm/config";
      description = "Directory to store ARM configuration and database.";
    };

    mediaDir = mkOption {
      type = types.path;
      default = "/home/arm/media";
      description = "Base directory where ripped media will be stored.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      extraGroups = [
        "video"
        "render"
        "cdrom"
      ];
      home = cfg.dataDir;
      createHome = true;
    };

    systemd.services.arm-ui = {
      description = "Automatic Ripping Machine UI";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        ARM_CONFIG_DIR = "${cfg.dataDir}/config";
        PYTHONPATH = "${armPkg}/share/automatic-ripping-machine";
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${armPkg}/bin/arm-ui";
        Restart = "always";
        RestartSec = "10";
        preStart = ''
          if [ ! -d "${cfg.dataDir}/config" ]; then
            mkdir -p ${cfg.dataDir}/{db,logs,config}
          fi
          if [ ! -d "${cfg.mediaDir}" ]; then
            mkdir -p ${cfg.mediaDir}/{music,media/raw,media/transcode,media/completed}
          fi
          chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
          chown -R ${cfg.user}:${cfg.group} ${cfg.mediaDir}
          ln -sf $out/share/automatic-ripping-machine/setup/arm.yaml ${cfg.dataDir}/config/arm.yaml
          ln -sf $out/share/automatic-ripping-machine/setup/apprise.yaml ${cfg.dataDir}/config/apprise.yaml
          ln -sf $out/share/automatic-ripping-machine/setup/.abcde.conf ${cfg.dataDir}/config/abcde.conf
        '';
      };
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="block", KERNEL=="sr[0-9]*", ACTION=="change", RUN+="${armPkg}/bin/arm-ui --trigger-udev"
    '';
  };
}

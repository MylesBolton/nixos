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

    armUser = mkOption {
      type = types.str;
      default = "arm";
      description = "User account under which ARM runs.";
    };

    armGroup = mkOption {
      type = types.str;
      default = "arm";
      description = "Group account under which ARM runs";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/home/arm/config";
      description = "Directory to store ARM configuration and Data.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isNormalUser = true;
      group = cfg.group;
      description = "Automatic Ripping Machine User";
      extraGroups = [
        "video"
        "render"
        "cdrom"
        "docker"
      ];
      home = cfg.dataDir;
      createHome = true;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}/music  0755 ${cfg.armUser} ${cfg.armGroup} -"
      "d ${cfg.dataDir}/logs   0755 ${cfg.armUser} ${cfg.armGroup} -"
      "d ${cfg.dataDir}/media  0755 ${cfg.armUser} ${cfg.armGroup} -"
      "d ${cfg.dataDir}/config 0755 ${cfg.armUser} ${cfg.armGroup} -"
    ];

    virtualisation.oci-containers.containers.arm-rippers = {
      image = "automaticrippingmachine/automatic-ripping-machine:latest";
      autoStart = true;

      ports = [ "8080:8080" ];

      environment = {
        TZ = config.time.timeZone;
      };

      volumes = [
        "${cfg.dataDir}:/home/arm"
        "${cfg.dataDir}/music:/home/arm/music"
        "${cfg.dataDir}/logs:/home/arm/logs"
        "${cfg.dataDir}/media:/home/arm/media"
        "${cfg.dataDir}/config:/etc/arm/config"
      ];

      extraOptions = [
        "--privileged"
        "--device=/dev/sr0:/dev/sr0"
      ];
    };

    services.udev.extraRules = ''
      KERNEL=="sr*", GROUP="cdrom", MODE="0660"
    '';
  };
}

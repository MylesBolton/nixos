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

    dataDir = mkOption {
      type = types.path;
      default = "/home/arm/config";
      description = "Directory to store ARM configuration and Data.";
    };
  };

  config = mkIf cfg.enable {

    users.groups.arm.gid = 1001;

    users.users.arm = {
      isNormalUser = true;
      home = "/home/arm";
      uid = 1001;
      homeMode = "755";
      group = "arm";
      extraGroups = [
        "cdrom"
        "video"
      ];
    };

    systemd.tmpfiles.rules = [
      "d /home/arm/music 0755 arm arm"
      "d /home/arm/logs 0755 arm arm"
      "d /home/arm/media 0755 arm arm"
      "d /home/arm/media/raw 0755 arm arm"
      "d /home/arm/media/transcode 0755 arm arm"
      "d /home/arm/media/transcode/movies 0755 arm arm"
      "d /home/arm/media/transcode/unidentified 0755 arm arm"
      "d /home/arm/media/completed 0755 arm arm"
      "d /home/arm/config 0755 arm arm"
      "d /home/arm/db 0755 arm arm"
    ];

    virtualisation.oci-containers = {
      containers = {
        arm = {
          autoStart = true;
          image = "docker.io/aric49/automatic-ripping-machine:2.20.5";
          volumes = [
            "/home/arm:/home/arm"
            "/home/arm/music:/home/arm/music"
            "/home/arm/logs:/home/arm/logs"
            "/home/arm/media:/home/arm/media"
            "/home/arm/config:/etc/arm/config"
          ];
          ports = [ "8080:8080" ];
          environment = {
            ARM_UID = "1001";
            ARM_GID = "1001";
          };
          extraOptions = [
            "--privileged"
            "--device=/dev/sr0:/dev/sr0"
          ];
        };
      };
    };
  };
}

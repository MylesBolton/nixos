{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.automatic-ripping-machine;
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
        "render"
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

    services.udev.extraRules = ''
      # Ignore the drive in udisks to prevent desktop mounting interference
      SUBSYSTEM=="block", KERNEL=="sr0", ENV{UDISKS_IGNORE}="1"

      # Ensure the sg module is loaded for the CD-ROM
      SUBSYSTEM=="scsi", ENV{DEVTYPE}=="scsi_device", TEST!="sg", RUN+="${pkgs.kmod}/bin/modprobe sg"
    '';

    virtualisation.oci-containers = {
      containers = {
        arm = {
          autoStart = true;
          image = "automaticrippingmachine/automatic-ripping-machine:latest";
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
            "--pull=always"
            "--device=/dev/sr0:/dev/sr0"
            "--device=/dev/sg0:/dev/sg0"
            "--device=/dev/dri/card0:/dev/dri/card0"
            "--device=/dev/dri/renderD128:/dev/dri/renderD128"
            "--device=/dev/dri/card1:/dev/dri/card1" # todo wait for b580 driver support on ARM docker image (XE Driver for Intel Arc)
            "--device=/dev/dri/renderD129:/dev/dri/renderD129"
            "--group-add=cdrom"
            "--group-add=26"
            "--group-add=303"
          ];
        };
      };
    };
  };
}

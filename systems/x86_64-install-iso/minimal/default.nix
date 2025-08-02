{ lib, namespace, ... }:
{
  roles = {
    common = {
      enable = true;
    };
  };

  styles.stylix.enable = true;

  boot = {
    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
    ];
  };

  fileSystems."/nix/.rw-store" = {
    fsType = "tmpfs";
    options = [
      "mode=0755"
      "nosuid"
      "nodev"
      "relatime"
      "size=32G"
    ];
    neededForBoot = true;
  };

  system.stateVersion = "24.05";
}

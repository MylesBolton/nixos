{ lib, namespace, ... }:
{
  custom = {
    user = {
      name = "nixos";
      initialPassword = "1337";
    };
    system = {
      nix.enable = true;
      networking.enable = true;
      locale.enable = true;
      boot.enable = true;
    };
    services = {
      openssh.enable = true;
      tailscale.enable = true;
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

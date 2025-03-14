{ lib, namespace, ... }:
{
  system = {
    custom = {
      nix.enable = true;
      networking.enable = true;
      locale.enable = true;
      boot.enable = true;
    };
  };

  services = {
    openssh.enable = true;
    custom = {
      tailscale.enable = true;
    };
  };
  styles.stylix.enable = true;

  user = {
    name = "nixos";
    initialPassword = "1337";
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

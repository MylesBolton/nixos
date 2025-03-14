{lib, namespace, ...}: {
  roles = {
    common.enable = true;
  };

  system = {
    custom = {
      bluetooth.enable = true;
      battery.enable = true;
      desktop = {
        enable = true;
        gnome = true;
      };
    };
  };

  user = {
    name = "user";
    initialPassword = "1337";
  };

  fileSystems."/nix/.rw-store" = {
    fsType = "tmpfs";
    options = [ "mode=0755" "nosuid" "nodev" "relatime" "size=32G" ];
    neededForBoot = true;
  };

  system.stateVersion = "24.05";
}
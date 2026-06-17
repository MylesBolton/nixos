{
  namespace,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "laptop-02";

  snowfallorg.users = {
    aj.admin = false;
    mb.admin = false;
    jb.admin = false;
    jj.admin = false;
  };

  custom.roles = {
    desktop = {
      enable = true;
      gnome.enable = true;
    };
  };

  system.stateVersion = "24.05";
}

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

  networking.hostName = "laptop-03";

  snowfallorg.users = {
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

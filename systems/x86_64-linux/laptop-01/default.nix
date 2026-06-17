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
  facter.reportPath = if (builtins.pathExists ./facter.json) then ./facter.json else null;

  networking.hostName = "laptop-01";

  custom.roles = {
    desktop = {
      enable = true;
      gnome.enable = true;
    };
  };

  system.stateVersion = "24.05";
}

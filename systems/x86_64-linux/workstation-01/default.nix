{
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.custom;
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];
  facter.reportPath = if (builtins.pathExists ./facter.json) then ./facter.json else null;

  networking.hostName = "workstation-01";

  services.automatic-ripping-machine = {
    enable = true;
  };

  roles = {
    desktop = {
      enable = true;
      gnome.enable = true;
    };
    gaming.enable = true;
  };
}

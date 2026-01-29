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

  roles = {
    desktop = {
      enable = true;
      gnome.enable = true;
    };
  };

  boot = {
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.stateVersion = "24.05";
}

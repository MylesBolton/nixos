{ lib, pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "workstation-01";

  roles = {
    common.enable = true;
    gaming.enable = true;
  };
  custom = {
    system = {
      bluetooth.enable = true;
      desktop = {
        enable = true;
        gnome = true;
      };
    };
  };

  boot = {
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.stateVersion = "24.05";
}

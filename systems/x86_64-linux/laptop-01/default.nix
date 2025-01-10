{ namespace, lib, pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "laptop-01";
  
    roles = {
      common.enable = true;
      desktop.enable = true;
    };

    system.${namespace}.battery.enable = true;

  boot = {
    supportedFilesystems = lib.mkForce ["btrfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

    system.stateVersion = "24.05";
}
{ lib, pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "desktop-01";

  custom.system.networking.wifi = {
    enable = true;
    guest = true;
    home = true;
  };

  roles = {
    desktop = {
      enable = true;
      gnome.enable = true;
    };
    gaming.enable = true;
  };

  boot = {
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.stateVersion = "24.05";
}

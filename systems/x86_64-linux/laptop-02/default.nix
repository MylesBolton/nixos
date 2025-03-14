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

  boot = {
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.stateVersion = "24.05";
}

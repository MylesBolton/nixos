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

  roles = {
    desktop = {
      enable = true;
      kde.enable = true;
    };
  };

  boot = {
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.stateVersion = "24.05";
}

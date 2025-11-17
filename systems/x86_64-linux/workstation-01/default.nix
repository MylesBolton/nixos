{
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.custom;
{
  facter.reportPath = if (builtins.pathExists ./facter.json) then ./facter.json else null;
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "workstation-01";

  roles = {
    desktop = {
      enable = true;
      gnome.enable = true;
    };
    gaming.enable = true;
  };

  #hardware.graphics.extraPackages = with pkgs; [
  #  intel-media-driver
  #  intel-compute-runtime
  #  vpl-gpu-rt
  #];

  environment.variables = {
    GSK_RENDERER = "gl";
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  boot = {
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.stateVersion = "24.05";
}

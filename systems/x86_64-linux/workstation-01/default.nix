{ lib, pkgs, ... }:
{
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

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    clinfo
    glxinfo
    nvtopPackages.intel
    vulkan-tools
  ];

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-compute-runtime
    vpl-gpu-rt
    libvdpau-va-gl
  ];

  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [
    intel-media-driver
    libvdpau-va-gl
  ];

  boot = {
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.stateVersion = "24.05";
}

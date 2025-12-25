{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  environment.variables = {
    GSK_RENDERER = "opengl";
  };

  environment.sessionVariables = {
    DRI_PRIME = "1";
    ONEVPL_PREFER_DEVICE = "discrete";
    NEOReadDebugKeys = "1";
  };

  hardware = {
    intel-gpu-tools.enable = true;
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # Best for i9-10900K iGPU
        vpl-gpu-rt # Required for B580 (Battlemage) Video logic
        intel-compute-runtime # OpenCL for both GPUs
        libva
        libdrm
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        libva
        libdrm
      ];
    };
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  boot = {
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.stateVersion = "24.05";
}

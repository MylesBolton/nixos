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

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="36b0", MODE="0666"
  '';

  environment.sessionVariables = {
    ONEVPL_PREFER_DEVICE = "discrete";
    NEOReadDebugKeys = "1";
    LIBVA_DRIVER_NAME = "iHD";
    LIBVA_DRM_DEVICE = "/dev/dri/renderD129";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    MESA_VK_DEVICE_SELECT = "pci:0000:03:00.0";
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

  services.switcherooControl.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];

  boot = {
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
    kernelParams = [
      "pci=realloc"
      "pcie_aspm=off"
    ];
  };

  system.stateVersion = "24.05";
}

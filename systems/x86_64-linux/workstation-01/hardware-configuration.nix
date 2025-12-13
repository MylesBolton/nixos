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
    GSK_RENDERER = "gl"; # stops wierd driver problems for intel B580 GPU
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware = {
    intel-gpu-tools.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # QuickSync (iHD)
        vpl-gpu-rt # Modern Video Processing Library
        intel-compute-runtime # OpenCL/Compute
        libva-vdpau-driver
        libvdpau-va-gl
        mesa
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        mesa
        libvdpau-va-gl
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
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

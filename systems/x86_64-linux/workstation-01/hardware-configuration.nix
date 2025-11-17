{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "sr_mod"
      "atlantic"
      "iwlwifi"
    ];
    initrd.extraFirmwarePaths = [ "iwlwifi-ty-a0-gf-a0-89.ucode.zst" ];
    kernelModules = [
      "kvm-intel"
      "sg"
      "xe"
    ];
  };
  boot.kernelParams = [ "xe.enable_guc=3" ];
  boot.extraModulePackages = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

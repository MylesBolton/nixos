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
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [
    "xe"
    "i915"
  ];
  boot.kernelModules = [
    "kvm-intel"
    "sg"
    "xe"
    "i915"
  ];
  boot.kernelParams = [
    "i915.force_probe=1901"
    "xe.force_probe=1901"
    "i915.force_probe=e20b"
    "xe.force_probe=e20b"
    "i915.enable_guc=2"
  ];
  boot.extraModulePackages = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

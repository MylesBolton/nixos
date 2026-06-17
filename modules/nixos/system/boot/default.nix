{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.system.boot;
in
{
  options.custom.system.boot = with types; {
    enable = mkBoolOpt false "Whether or not to enable booting.";
    kernelPackages =
      mkOpt raw pkgs.cachyosKernels.linuxPackages-cachyos-lts
        "The kernel packages to use.";
    supportedFilesystems = mkOpt (listOf str) [ "btrfs" ] "The supported filesystems.";
  };

  config = mkIf cfg.enable {
    boot.tmp.useTmpfs = true;
    boot.tmp.tmpfsSize = "50%";

    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 8;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };

    boot.supportedFilesystems = lib.mkDefault cfg.supportedFilesystems;
    boot.kernelPackages = lib.mkDefault cfg.kernelPackages;
  };
}

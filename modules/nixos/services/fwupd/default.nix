{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.services.fwupd;
in
{
  options.custom.services.fwupd = {
    enable = mkEnableOption "Enable fwupd for firmware updates";
  };

  config = mkIf cfg.enable {
    services.fwupd.enable = true;
    environment.systemPackages = [ pkgs.fwupd ];
  };
}

{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.system.power;
in
{
  options.custom.system.power = {
    enable = mkEnableOption "Enable power management";
  };

  config = mkIf cfg.enable {
    services.tlp.enable = true;
  };
}

{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.system.zram;
in
{
  options.custom.system.zram = {
    enable = mkEnableOption "Enable zram swap";
  };

  config = mkIf cfg.enable {
    zramSwap.enable = true;
  };
}

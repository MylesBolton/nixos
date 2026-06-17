{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.system.oom;
in
{
  options.custom.system.oom = {
    enable = mkEnableOption "Enable systemd-oomd for better memory management";
  };

  config = mkIf cfg.enable {
    systemd.oomd = {
      enable = true;
      enableUserSlices = true;
      enableSystemSlice = true;
    };
  };
}

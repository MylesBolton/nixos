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
    mode = mkOpt (types.enum [ "tlp" "auto-cpufreq" "power-profiles-daemon" ]) "tlp" "Which power management tool to use.";
  };

  config = mkIf cfg.enable {
    services.tlp.enable = cfg.mode == "tlp";
    services.auto-cpufreq.enable = cfg.mode == "auto-cpufreq";
    services.power-profiles-daemon.enable = cfg.mode == "power-profiles-daemon";
  };
}

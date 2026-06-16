{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.roles.laptop;
in
{
  options.custom.roles.laptop = with types; {
    enable = mkBoolOpt false "laptop nixos configuration.";
  };

  config = mkIf cfg.enable {
    custom = {
      system = {
        battery.enable = true;
        bluetooth.enable = true;
        power.enable = true;
      };
    };
  };
}

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
  cfg = config.roles.laptop;
in
{
  options.roles.laptop = with types; {
    enable = mkBoolOpt false "laptop nixos configuration.";
  };

  config = mkIf cfg.enable {
    custom = {
      system = {
        battery.enable = true;
      };
    };
  };
}

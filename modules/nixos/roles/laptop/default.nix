{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.roles.laptop;
in
{
  options.roles.laptop = with types; {
    enable = mkBoolOpt false "laptop nixos configuration.";
  };

  config = mkIf cfg.enable {
    
      system.${namespace}.battery.enable = true;
  };
}
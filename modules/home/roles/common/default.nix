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
  cfg = config.roles.common;
in
{
  options.roles.common = with types; {
    enable = mkBoolOpt false "Enable common role";
  };

  config = mkIf cfg.enable {
    custom.system.nix.enable = true;
    cli.shells.fish.enable = true;
    styles.stylix.enable = true;
  };
}


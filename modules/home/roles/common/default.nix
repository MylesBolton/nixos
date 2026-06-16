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
  cfg = config.custom.roles.common;
in
{
  options.custom.roles.common = with types; {
    enable = mkBoolOpt false "Enable common role";
  };

  config = mkIf cfg.enable {
    custom.system.nix.enable = true;
    custom.cli.shells.fish.enable = true;
    custom.cli.direnv.enable = true;
    custom.styles.stylix.enable = true;
  };
}

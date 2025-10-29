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
  cfg = config.roles.priv;
in
{
  options.roles.priv = with types; {
    enable = mkBoolOpt false "enable priv role";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tor-browser
      onioncircuits
    ];
  };
}

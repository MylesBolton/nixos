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
  cfg = config.custom.roles.priv;
in
{
  options.custom.roles.priv = with types; {
    enable = mkBoolOpt false "enable priv role";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mullvad-vpn
      tor-browser
      onioncircuits
    ];
  };
}

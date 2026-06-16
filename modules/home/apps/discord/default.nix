{
  inputs,
  lib,
  host,
  pkgs,
  config,
  namespace,
  ...
}:
with lib;
let
  cfg = config.custom.apps.discord;
in
{
  options.custom.apps.discord = {
    enable = mkEnableOption "enable discord";
  };

  config = mkIf cfg.enable {
    xdg.configFile."BetterDicord/data/stable/custom.css" = {
      source = ./custom.css;
    };
    home.packages = with pkgs; [ goofcord ];
  };
}

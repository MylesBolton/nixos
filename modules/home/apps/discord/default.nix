{
  inputs,
  lib,
  host,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.apps.discord;
in {
  options.apps.discord = {
    enable = mkEnableOption "enable discord";
  };

  config = mkIf cfg.enable {
    xdg.configFile."BetterDicord/data/stable/custom.css" = {source = ./custom.css;};
    home.packages = with pkgs; [goofcord];
  };
}
{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.terminals.ghostty;
in
{
  options.cli.terminals.ghostty = {
    enable = mkEnableOption "enable ghostty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        font-size = 16;
        background-opacity = 0.95;
        window-padding-x = 10;
        window-padding-y = 10;
        window-decoration = "client";
        cursor-style-blink = "true";
      };
    };
  };
}

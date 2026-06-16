{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.custom.cli.terminals.ghostty;
in
{
  options.custom.cli.terminals.ghostty = {
    enable = mkEnableOption "enable ghostty terminal emulator";
  };

  config = mkIf cfg.enable {
    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "ghostty.desktop" ];
    };

    stylix.targets.ghostty.fonts.enable = false;
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        command = "fish";
        font-family = "Atkinson Hyperlegible Mono";
        font-family-bold = "Atkinson Hyperlegible Mono";
        font-family-italic = "Atkinson Hyperlegible Mono";
        font-family-bold-italic = "Atkinson Hyperlegible Mono";
        window-padding-x = 10;
        window-padding-y = 10;
        window-decoration = "client";
        cursor-style-blink = "true";
      };
    };
  };
}

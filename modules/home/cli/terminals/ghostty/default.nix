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
    stylix.targets.ghostty.fonts.enable = false;
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
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

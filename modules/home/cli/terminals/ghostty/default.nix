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
        theme = "catppuccin-mocha";
        window-opacity = 0.95;
        window-padding-x = 10;
        window-padding-y = 10;
        window-decoration = "full";
        cursor-blink = "On";

        keybind = [
          "ctrl+plus=increase_font_size"
          "ctrl+minus=decrease_font_size"
          "ctrl+0=reset_font_size"
          "ctrl+shift+n=new_window"
          "ctrl+shift+t=new_tab"
          "ctrl+shift+w=close_tab"
          "ctrl+tab=next_tab"
          "ctrl+shift+tab=previous_tab"
          "ctrl+shift+d=new_split:right"
          "ctrl+shift+e=new_split:down"
          "ctrl+shift+q=close_split"
          "ctrl+h=goto_split:left"
          "ctrl+j=goto_split:down"
          "ctrl+k=goto_split:up"
          "ctrl+l=goto_split:right"
        ];
      };
    };
  };
}

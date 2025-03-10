{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cli.terminals.ghostty;
in {
  options.cli.terminals.ghostty = {
    enable = mkEnableOption "enable ghostty terminal emulator";
  };

  config = mkIf cfg.enable {
    xdg.configFile."ghostty/config".text = ''
      theme = catppuccin-mocha
      font-family = "b612 Nerd Font"
      command = fish
      font-size = 14
      window-padding-x = 6
      window-padding-y = 6
      cursor-style = block
    '';

    home.packages = with inputs; [
      ghostty.packages.${pkgs.system}.default
    ];
  };
}

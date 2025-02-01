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
  cfg = config.roles.desktop;
in
{
  options.roles.desktop = with types; {
    enable = mkBoolOpt false "enable desktop role";
  };

  config = mkIf cfg.enable {
    services.custom = {
      kdeconnect.enable = true;
    };
    cli.terminals.ghostty.enable = true;
    apps.firefox.enable = true;
    home.packages = with pkgs; [
      thunderbird
      vlc
      xpipe
      wl-clipboard
      vscode
    ];
  };
}
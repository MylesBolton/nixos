{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.roles.desktop;
in
{
  options.roles.desktop = with types; {
    enable = mkBoolOpt false "enable desktop role";
  };

  config = mkIf cfg.enable {
    cli.terminals.ghostty.enable = true;
    apps.firefox.enable = true;
    home.packages = with pkgs; [
      xpipe
      wl-clipboard
      vscode
    ];
  };
}
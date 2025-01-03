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
    home.packages = with pkgs; [
      xpipe
      wl-clipboard
      vscode
    ];
  };
}
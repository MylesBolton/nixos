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
    cli.terminals.ghostty.enable = true;
    apps.firefox.enable = true;
    custom.services = {
      syncthing.enable = true;
    };
    home.packages = with pkgs; [
      thunderbird
      vlc
      wl-clipboard
      keepassxc
      rustdesk
    ];
  };
}

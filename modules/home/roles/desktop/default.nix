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
      mkchromecast
      #rustdesk
    ];
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "blur-my-shell@aunetx"
          "caffeine@patapon.info"
          "dash-to-dock@micxgx.gmail.com"
          "gsconnect@andyholmes.github.io"
          "sound-percentage@subashghimire.info.np"
          "syncthing@gnome.2nv2u.com"
          "tactile@lundal.io"
        ];
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        always-center-icons = true;
        animation-time = 0.10000000000000002;
        apply-custom-theme = false;
        background-color = "rgb(21,23,35)";
        background-opacity = 1.0;
        click-action = "focus-minimize-or-previews";
        custom-background-color = true;
        custom-theme-shrink = true;
        dash-max-icon-size = 36;
        dock-fixed = false;
        dock-position = "BOTTOM";
        extend-height = false;
        height-fraction = 0.9;
        hide-delay = 0.2;
        hide-tooltip = false;
        icon-size-fixed = false;
        intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
        isolate-monitors = true;
        isolate-workspaces = true;
        middle-click-action = "launch";
        pressure-threshold = 50.0;
        running-indicator-style = "METRO";
        scroll-action = "cycle-windows";
        scroll-to-focused-application = true;
        shift-click-action = "minimize";
        shift-middle-click-action = "quit";
        show-apps-always-in-the-edge = false;
        show-apps-at-top = true;
        show-favorites = true;
        show-mounts-network = true;
        show-trash = true;
        transparency-mode = "DEFAULT";
      };
    };
  };
}

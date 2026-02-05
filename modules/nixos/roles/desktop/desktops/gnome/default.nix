{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.roles.desktop.gnome;
in
{
  options.roles.desktop.gnome = with types; {
    enable = mkBoolOpt false "Enable Gnome desktop environment";
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };
      displayManager.gdm = {
        enable = true;
        settings.greeter = {
          Exclude = "user";
        };
      };
      desktopManager.gnome.enable = true;
    };

    dconf.settings = {
      "org/gnome/mutter" = {
        check-alive-timeout = lib.gvariant.mkUint32 120000;
      };
    };

    environment.systemPackages = with pkgs.gnomeExtensions; [
      blur-my-shell
      headsetcontrol
      tactile
      syncthing-indicator
      dash-to-dock
      caffeine
      sound-percentage
      gsconnect
    ];
    environment.gnome.excludePackages = (
      with pkgs;
      [
        baobab
        decibels
        epiphany
        gnome-text-editor
        gnome-calendar
        gnome-characters
        gnome-contacts
        gnome-font-viewer
        gnome-logs
        gnome-maps
        gnome-music
        gnome-weather
        loupe
        gnome-connections
        totem
        yelp
      ]
    );
  };
}

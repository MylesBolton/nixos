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
  cfg = config.custom.roles.desktop.gnome;
in
{
  options.custom.roles.desktop.gnome = with types; {
    enable = mkBoolOpt false "Enable Gnome desktop environment";
    numlock = mkBoolOpt false "Enable numlock on boot";
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

    programs.dconf.profiles.gdm.databases = mkIf cfg.numlock [
      {
        settings = {
          "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = true;
          };
        };
      }
    ];

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

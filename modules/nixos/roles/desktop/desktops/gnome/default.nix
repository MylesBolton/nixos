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
        atomix
        cheese
        epiphany
        evince
        geary
        gedit
        gnome-characters
        gnome-music
        gnome-photos
        gnome-terminal
        gnome-tour
        hitori
        iagno
        tali
        totem
      ]
    );
  };
}

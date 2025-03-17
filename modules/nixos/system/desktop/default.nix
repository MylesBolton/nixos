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
  cfg = config.custom.system.desktop;
in
{
  options.custom.system.desktop = with types; {
    enable = mkBoolOpt false "Enable desktop environment";
    kde = mkBoolOpt false "Enable KDE Plasma";
    gnome = mkBoolOpt false "Enable Gnome";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services = {
        xserver = {
          excludePackages = [ pkgs.xterm ];
        };
        printing.enable = true;
      };
    }

    (mkIf cfg.kde {
      services = {
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          settings = {
            users.HideUsers = "user";
          };
        };
        desktopManager.plasma6.enable = true;
        displayManager.defaultSession = "plasma";
      };

      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        gwenview
        konsole
        oxygen
        kate
        elisa
        khelpcenter
        kwallet
        kwalletmanager
      ];
      environment.systemPackages = with pkgs; [ kdePackages.filelight ];
      programs.dconf.enable = true;
    })

    (mkIf cfg.gnome {
      services.xserver = {
        enable = true;
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
    })
  ]);
}

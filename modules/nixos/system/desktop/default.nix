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
  cfg = config.system.custom.desktop;
in
{
  options.system.custom.desktop = with types; {
    enable = mkBoolOpt false "Enable desktop environment";
    kde = mkBoolOpt false "Enable KDE Plasma";
    xfce = mkBoolOpt false "Enable xfce";
    gnome = mkBoolOpt false "Enable Gnome";
  };
  config = mkIf cfg.enable (mkMerge [
    {
      services = {
        xserver = {
          enable = true;
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

    (mkIf cfg.xfce {
      services = {
        xserver = {
          desktopManager = {
            xterm.enable = false;
            xfce.enable = true;
          };
        };
        displayManager.defaultSession = "xfce";
      };
    })
    (mkIf cfg.gnome {
      services.xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };

      environment.systemPackages = with pkgs.gnomeExtensions; [
        blur-my-shell
        headsetcontrol
        kimpanel
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

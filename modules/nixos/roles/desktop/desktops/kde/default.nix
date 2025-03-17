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
  cfg = config.roles.desktop.kde;
in
{
  options.roles.desktop.kde = with types; {
    enable = mkBoolOpt false "Enable KDE desktop environment";
  };

  config = mkIf cfg.enable {
      services = {
        #xserver = {
        #  excludePackages = [ pkgs.xterm ];
        #};
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          settings = {
            Users.HideUsers = "user";
          };
        };
        desktopManager.plasma6.enable = true;
        displayManager.defaultSession = "plasma";
      };

      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        konsole
        ark
        elisa
        gwenview
        okular
        kate
        khelpcenter
        spectacle
        krdp
      ];
      programs.dconf.enable = true;
    };
}

{ pkgs, namespace, ... }:
{

  roles = {
    common.enable = true;
    desktop.enable = true;
    office.enable = true;
    gaming.enable = true;
    social.enable = true;
    rot.enable = true;
    cad.enable = true;
  };
  styles.stylix.wallpaper = "dark-star";

  custom.user = {
    enable = true;
    name = "jb";
  };

  home.stateVersion = "24.05";
}

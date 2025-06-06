{ pkgs, namespace, ... }:
{

  roles = {
    common.enable = true;
    desktop.enable = true;
    office.enable = true;
    gaming.enable = true;
    social.enable = true;
    rot.enable = true;
    dev.enable = true;
  };

  styles.stylix.wallpaper = "tree";

  custom.user = {
    enable = true;
    name = "user";
  };

  home.stateVersion = "24.05";
}

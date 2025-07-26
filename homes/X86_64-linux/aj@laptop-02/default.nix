{ pkgs, namespace, ... }:
{

  roles = {
    common.enable = true;
    desktop.enable = true;
    office.enable = true;
    rot.enable = true;
  };

  styles.stylix.wallpaper = "soft-rose";

  custom.user = {
    enable = true;
    name = "aj";
  };

  home.stateVersion = "24.05";
}

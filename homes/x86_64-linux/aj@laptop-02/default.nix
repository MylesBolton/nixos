{ pkgs, namespace, ... }:
{

  custom.roles = {
    common.enable = true;
    desktop.enable = true;
    office.enable = true;
    rot.enable = true;
  };

  custom.styles.stylix.wallpaper = "soft-rose";

  custom.user = {
    enable = true;
    name = "aj";
  };

}

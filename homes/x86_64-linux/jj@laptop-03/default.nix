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
    cad.enable = true;
  };
  styles.stylix = {
    wallpaper = "panes";
  };
  home.packages = with pkgs; [
    vista-fonts
  ];
  custom.user = {
    enable = true;
    name = "jj";
  };

  home.stateVersion = "24.05";
}

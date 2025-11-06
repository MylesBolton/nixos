{ pkgs, namespace, ... }:
{

  roles = {
    common.enable = true;
    desktop.enable = true;
    dev.enable = true;
    priv.enable = true;
  };

  custom.user = {
    enable = true;
    name = "user";
  };

  home.stateVersion = "24.05";
}

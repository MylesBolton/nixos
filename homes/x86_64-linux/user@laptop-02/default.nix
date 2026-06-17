{ pkgs, namespace, ... }:
{

  custom.roles = {
    common.enable = true;
    desktop.enable = true;
    dev.enable = true;
    priv.enable = true;
  };

  custom.user = {
    enable = true;
    name = "user";
  };

}

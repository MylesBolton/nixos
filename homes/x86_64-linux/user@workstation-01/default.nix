{
  pkgs,
  namespace,
  ...
}:
{
  custom.roles = {
    common.enable = true;
    desktop = {
      enable = true;
      numlock = true;
    };
    office.enable = true;
    gaming.enable = true;
    social.enable = true;
    rot.enable = true;
    dev.enable = true;
    cad.enable = true;
    priv.enable = true;
    sec.enable = false;
  };

  custom.user = {
    enable = true;
    name = "user";
    stateVersion = "26.05";
  };
}

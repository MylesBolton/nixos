{pkgs, namespace, ...}: {

  roles = {
    common.enable = true;
    desktop.enable = true;
    office.enable = true;
    gaming.enable = true;
    social.enable = true;
    rot.enable = true;
    dev.enable = true;
    ai.enable = true;
  };

  custom.user = {
      enable = true;
      name = "user";
    };
    
  home.stateVersion = "24.05";
}
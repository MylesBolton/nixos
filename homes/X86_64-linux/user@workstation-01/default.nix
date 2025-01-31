{pkgs, namespace, ...}: {

  roles = {
    common.enable = true;
    desktop.enable = true;
    office.enable = true;
    gaming.enable = true;
  };
  custom = {
    user = {
      enable = true;
      name = "user";
    };
    services = {
      syncthing.enable = true;
    };
  };
  
  home.stateVersion = "24.05";
}
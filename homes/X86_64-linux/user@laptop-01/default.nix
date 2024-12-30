{pkgs, namespace, ...}: {

  roles = {
    common.enable = true;
    desktop.enable = true;
    office.enable = true;
  };
  
  user = {
    enable = true;
    name = "user";
  };

  home.stateVersion = "25.05";
}
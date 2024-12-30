{pkgs, namespace, ...}: {

#  roles = {
#    desktop.enable = true;
#    office.enable = true;
#    social.enable = true;
#    gaming.enable = true;
#  };
  
  user = {
    enable = true;
    name = "user";
  };

  home.stateVersion = "23.11";
}
{ namespace, ... }:
{
  imports = [
    ./disko.nix
    #./hardware-configuration.nix
    ./secrets/secrets.nix
  ];

  networking.hostName = "laptop-01";
  
    roles = {
      common.enable = true;
      desktop.enable = true;
    };

    system.${namespace}.battery.enable = true;

    system.stateVersion = "25.05";
  }

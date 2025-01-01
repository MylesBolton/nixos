{ ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./secrets/secrets.nix
  ];

  networking.hostName = "workstation-01";
  
    roles = {
      common.enable = true;
      desktop.enable = true;
      gaming.enable = true;
    };

    system.stateVersion = "24.05";
  }

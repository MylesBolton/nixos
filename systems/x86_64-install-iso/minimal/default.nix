{lib, namespace, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.enable = lib.mkForce false;
  networking.networkmanager.enable = true;
  
  system = {
    ${namespace} = {
      nix.enable = true;
      networking.enable = true;
      locale.enable = true;
    };
  };
  services = {
    ${namespace} = {
      ssh.enable = true;
    };
  };

  custom.user = {
    name = "user";
    initialPassword = "1";
  };

  system.stateVersion = "24.05";
}
{lib, namespace, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.enable = lib.mkForce false;
  networking.networkmanager.enable = true;
  
  system = {
    custom = {
      nix.enable = true;
      networking.enable = true;
      locale.enable = true;
    };
  };
  services = {
    custom = {
      ssh.enable = true;
    };
  };

  user = {
    name = "user";
    initialPassword = "1";
  };

  system.stateVersion = "24.05";
}
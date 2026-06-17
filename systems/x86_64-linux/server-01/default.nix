{ lib, pkgs, ... }:

{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "server-01";

  custom.roles = {
    server.enable = true;
  };

  custom.services = {
    harmonia.enable = true;
    automation = {
      enable = true;
      interval = "daily";
    };
  };

  system.stateVersion = "24.11";
}

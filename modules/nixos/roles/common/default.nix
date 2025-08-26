{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.roles.common;
in
{
  options.roles.common = with types; {
    enable = mkBoolOpt false "common nixos configuration.";
  };

  config = mkIf cfg.enable {
    custom = {
      system = {
        nix.enable = true;
        networking.enable = true;
        locale.enable = true;
        boot.enable = true;
      };
      services = {
        openssh.enable = true;
      };
      user = {
        name = "user";
        initialPassword = "1337";
      };
    };
    environment.systemPackages = with pkgs; [
      gopass
      gnupg
      gpg-tui
      git
      unrar
      unzip
      zip
      btop
      pciutils
      lsscsi
      wget
      curl
      vim
      nmap
    ];
    styles.stylix.enable = true;
  };
}

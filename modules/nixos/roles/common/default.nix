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
    fonts = {
      packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
      enableDefaultPackages = true;
    };
    environment.systemPackages = with pkgs; [
      util-linux
      inetutils
      gopass
      gnupg
      git
      unrar
      unzip
      zip
      btop
      pciutils
      lsscsi
      wget
      curl
      nmap
      lshw
      lsscsi
      libva-utils
      usbutils
    ];
    styles.stylix.enable = true;
  };
}

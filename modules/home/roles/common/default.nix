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
    enable = mkBoolOpt false "Enable common role";
  };

  custom = mkIf cfg.enable {

  };

  config = mkIf cfg.enable {
    custom = {
      cli.shells.fish.enable = true;
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
      nmap
    ];
    styles.stylix.enable = true;
  };
}

}

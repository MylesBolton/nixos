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

  config = mkIf cfg.enable {
    custom.system.nix.enable = true;
    cli.shells.fish.enable = true;
    home.packages = with pkgs; [
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
      docker
    ];
    styles.stylix.enable = true;
  };
}


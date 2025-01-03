{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.roles.common;
in
{
  options.roles.common = with types; {
    enable = mkBoolOpt false "Enable common role";
  };

  config = mkIf cfg.enable {
    system.${namespace}.nix.enable = true;
    cli.shells.fish.enable = true;
    home.packages = with pkgs; [
      gopass
      gnupg
      unrar
      unzip
      zip
      btop
      pciutils
    ];
    styles.stylix.enable = true;
  };
}


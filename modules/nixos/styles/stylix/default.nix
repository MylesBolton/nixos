{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
let
  cfg = config.styles.stylix;
in
{
  options.styles.stylix = {
    enable = lib.mkEnableOption "Enable stylix";
  };

  config = lib.mkIf cfg.enable {
    fonts.enableDefaultPackages = true;
    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      homeManagerIntegration.autoImport = false;
      homeManagerIntegration.followSystem = false;

      image = pkgs.custom.wallpapers.main;

      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };

      fonts = {

        serif = {
          package = pkgs.atkinson-hyperlegible-next;
          name = "atkinson hyperlegible";
        };

        sansSerif = {
          package = pkgs.atkinson-hyperlegible-next;
          name = "atkinson hyperlegible";
        };

        monospace = {
          package = pkgs.atkinson-hyperlegible-mono;
          name = "atkinson hyperlegible mono";
        };

        emoji = {
          package = pkgs.openmoji-color;
          name = "OpenMoji Color";
        };
      };
    };
  };
}

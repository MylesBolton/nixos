{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.styles.stylix;
in
{
  options.styles.stylix = with types; {
    enable = mkBoolOpt false "Enable stylix";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      homeManagerIntegration.autoImport = false;
      homeManagerIntegration.followSystem = false;

      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };

      fonts = {
        serif = {
          package = pkgs.atkinson-hyperlegible-next;
          name = "Atkinson Hyperlegible Next";
        };

        sansSerif = {
          package = pkgs.atkinson-hyperlegible-next;
          name = "Atkinson Hyperlegible Next";
        };

        monospace = {
          package = pkgs.atkinson-hyperlegible-mono;
          name = "atkinson-hyperlegible-mono";
        };

        emoji = {
          package = pkgs.openmoji-color;
          name = "OpenMoji Color";
        };
      };

      opacity = {
        applications = 0.95;
        terminal = 0.85;
        desktop = 1.0;
        popups = 0.95;
      };

      polarity = "dark";
    };
  };
}

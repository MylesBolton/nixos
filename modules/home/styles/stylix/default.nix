{
  lib,
  pkgs,
  config,
  inputs,
  namespace,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.styles.stylix;
in
{
  imports = with inputs; [
    stylix.homeModules.stylix
  ];

  options.styles.stylix = with types; {
    enable = mkBoolOpt false "Enable stylix";
    wallpaper = mkOpt str "jellyfish" "wallpaper name";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      image = pkgs.custom.wallpapers.${cfg.wallpaper};

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

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
  cfg = config.roles.gaming;
in
{
  options.roles.gaming = with types; {
    enable = mkBoolOpt false "enable gaming role";
  };

  config = mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        cpu_load_change = true;
      };
    };

    home.packages = with pkgs; [
      (pkgs.lutris.override {
        extraLibraries =
          pkgs: with pkgs; [
            libadwaita
            gtk4
          ];
      })
      dotnetCorePackages.runtime_9_0-bin
      bottles
      uesave
      #factorio-space-age
      prismlauncher
      vial
      via
    ];
  };
}

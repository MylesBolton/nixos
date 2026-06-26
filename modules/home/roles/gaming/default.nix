{
  options,
  config,
  lib,
  pkgs,
  namespace,
  osConfig ? { },
  inputs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.roles.gaming;
in
{
  options.custom.roles.gaming = with types; {
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
    programs.lutris = {
      enable = true;
      protonPackages = with pkgs; [
        proton-ge-bin
        proton-cachyos
      ];
      winePackages = with pkgs; [
        wineWow64Packages.waylandFull
        wineWow64Packages.staging
        wineWow64Packages.stable
      ];
    }
    // optionalAttrs (osConfig ? programs.steam.package) {
      steamPackage = osConfig.programs.steam.package;
    };

    home.packages = with pkgs; [
      dotnetCorePackages.runtime_9_0-bin
      uesave
      dolphin-emu
      wheelwizard
      prismlauncher
    ];
  };
}

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
    enable = mkBoolOpt false "gaming nixos configuration.";
  };

  config = mkIf cfg.enable {
    programs = {
      gamemode.enable = true;
      gamescope.enable = true;
      steam = {
        enable = true;
        package = pkgs.steam.override {
          extraPkgs =
            p: with p; [
              mangohud
              gamemode
            ];
        };
        dedicatedServer.openFirewall = true;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
          proton-cachyos
          wineWow64Packages.waylandFull
          wineWow64Packages.staging
          wineWow64Packages.stable
        ];
      };
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.systemPackages = with pkgs; [
      libadwaita
      cartridges
      steamtinkerlaunch
      winetricks
      protontricks
      protonup-qt
    ];

    services.ratbagd.enable = true;
  };
}

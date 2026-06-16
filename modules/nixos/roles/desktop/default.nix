{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.roles.desktop;
in
{
  options.custom.roles.desktop = with types; {
    enable = mkBoolOpt false "Enable desktop environment";
  };

  config = mkIf cfg.enable {

    custom.roles = {
      common.enable = true;
    };

    custom = {
      services = {
        avahi.enable = true;
        tailscale.enable = true;
        virtualisation.podman.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      firefox
      thunderbird
      vlc
      wl-clipboard
      rustdesk-flutter
      ghostty
      lshw-gui
      nvtopPackages.full
      piper
      qmk
      vial
      via
    ];

    services = {
      printing.enable = true;
      udev.packages = with pkgs; [
        vial
        via
      ];
    };
  };
}

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
  cfg = config.roles.desktop;
in
{
  options.roles.desktop = with types; {
    enable = mkBoolOpt false "Enable desktop environment";
  };

  config = mkIf cfg.enable {

    roles = {
      common.enable = true;
    };

    custom = {
      services = {
        avahi.enable = true;
        tailscale.enable = true;
        virtualisation.podman.enable = true;
      };
      system = {
        networking = {
          wifi = {
            enable = true;
            guest = true;
          };
        };
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
    ];

    services = {
      printing.enable = true;
    };
  };
}

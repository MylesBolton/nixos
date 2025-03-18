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
        boot.plymouth = true;
        battery.enable = true;
      };
    };

    ##### Default #####
      environment.systemPackages = with pkgs; [
        firefox
        thunderbird
        vlc
        wl-clipboard
        #rustdesk
        ghostty   
    ];

    services = {
      printing.enable = true;
    };
  };
}

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
  cfg = config.roles.desktop;
in
{
  options.roles.desktop = with types; {
    enable = mkBoolOpt false "nixos desktop configuration.";
  };

  config = mkIf cfg.enable {

    services = {
        xserver.enable = true;
        displayManager.sddm.enable = true;
        desktopManager.plasma6.enable = true;
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      oxygen
      kate
      elisa
      khelpcenter
      kwallet
      kwalletmanager
    ];

      system = {
        ${namespace} = {
          bluetooth.enable = true;
        };
      };
    };
  }
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

      system = {
        ${namespace} = {
          bluetooth.enable = true;
        };
      };
    };
  }
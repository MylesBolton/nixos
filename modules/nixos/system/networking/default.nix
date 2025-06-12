{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.system.networking;
in
{
  options.custom.system.networking = with types; {
    enable = mkBoolOpt false "Whether or not to manage networking settings.";
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
      wireless = {
        enable = true;
        networks = {
          "Guest WIFI" = {
            psk = "ThePassword";
          };
        };
      };
    };
  };
}

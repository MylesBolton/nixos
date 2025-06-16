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
    wifi = mkOption {
      type = types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Whether or not to enable and manage wifi.";
          };
          guest = mkOption {
            type = types.bool;
            default = false;
            description = "Whether or not to enable the Guest wifi network.";
          };
          home = mkOption {
            type = types.bool;
            default = false;
            description = "Whether or not to enable the Home wifi network.";
          };
          phion = mkOption {
            type = types.bool;
            default = false;
            description = "Whether or not to enable the Phion wifi network.";
          };
          uiot = mkOption {
            type = types.bool;
            default = false;
            description = "Whether or not to enable the Untrusted IoT network.";
          };
          tiot = mkOption {
            type = types.bool;
            default = false;
            description = "Whether or not to enable the Trusted IoT network.";
          };
        };
      };
      description = "WiFi network configuration.";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
      wireless = mkIf cfg.wifi.enable {
        networks = mkMerge [
          (mkIf cfg.wifi.guest {
            "Guest WiFi" = {
              psk = "ThePassword";
            };
          })
          (mkIf cfg.wifi.home {
            "Home WIFI" = {
              psk = "ThePassword";
            };
          })
          (mkIf cfg.wifi.phion {
            "Phion WIFI" = {
              psk = "ThePassword";
            };
          })
          (mkIf cfg.wifi.uiot {
            "UIOT WIFI" = {
              psk = "ThePassword";
            };
          })
          (mkIf cfg.wifi.tiot {
            "TIOT WIFI" = {
              psk = "ThePassword";
            };
          })
        ];
      };
    };
  };
}

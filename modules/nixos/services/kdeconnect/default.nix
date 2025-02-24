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
  cfg = config.services.custom.kdeconnect;
in
{
  options.services.custom.kdeconnect = with types; {
    enable = mkBoolOpt false "Enable kdeconnect";
  };

  config = mkIf cfg.enable {
    programs.kdeconnect.enable = true;
    networking.firewall = rec {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };
}
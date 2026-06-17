{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.services.harmonia;
in
{
  options.custom.services.harmonia = with types; {
    enable = mkBoolOpt false "Enable Harmonia Nix binary cache";
    port = mkOpt int 5000 "Port for Harmonia to listen on";
    priority = mkOpt int 50 "Priority for the cache";
  };

  config = mkIf cfg.enable {
    services.harmonia = {
      cache.enable = true;
      # settings.priority = cfg.priority;
    };

    # Open firewall port
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

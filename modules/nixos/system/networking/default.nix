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
      nameservers = [ "194.242.2.4#base.dns.mullvad.net" ];
      networkmanager.enable = true;
      firewall.enable = true;
    };

    services.resolved = {
      enable = true;
      settings = {
        Resolve = {
          DNSSEC = "true";
          Domains = [ "~." ];
          FallbackDNS = [ ];
          DNSOverTLS = "yes";
        };
      };
    };
  };
}

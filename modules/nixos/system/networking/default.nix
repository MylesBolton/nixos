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
  cfg = config.system.custom.networking;
in
{
  options.system.custom.networking = with types; {
    enable = mkBoolOpt false "Whether or not to manage networking settings.";
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
    };
  };
}
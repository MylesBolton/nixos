{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.system.${namespace}.networking;
in
{
  options.system.${namespace}.networking = with types; {
    enable = mkBoolOpt false "Whether or not to manage networking settings.";
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
    };
  };
}
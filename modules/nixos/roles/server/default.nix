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
  cfg = config.roles.server;
in
{
  options.roles.server = with types; {
    enable = mkBoolOpt false "Enable server role";
  };

  config = mkIf cfg.enable {

    roles = {
      common.enable = true;
    };

    custom = {
      services = {
        tailscale.enable = true;
      };
    };
  };
}

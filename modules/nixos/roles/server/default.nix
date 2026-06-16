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
  cfg = config.custom.roles.server;
in
{
  options.custom.roles.server = with types; {
    enable = mkBoolOpt false "Enable server role";
  };

  config = mkIf cfg.enable {

    custom.roles = {
      common.enable = true;
    };

    custom = {
      services = {
        tailscale.enable = true;
      };
    };
  };
}

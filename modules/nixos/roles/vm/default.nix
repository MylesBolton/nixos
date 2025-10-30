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
  cfg = config.roles.vm;
in
{
  options.roles.vm = with types; {
    enable = mkBoolOpt false "Enable VM role";
  };

  config = mkIf cfg.enable {

    roles = {
      common.enable = true;
    };
    services = {
      qemuGuest.enable = true;
      cloud-init = {
        enable = true;
        network.enable = true;
      };
    };
    custom = {
      services = {
        tailscale.enable = true;
        virtualisation.podman.enable = true;
      };
    };
  };
}

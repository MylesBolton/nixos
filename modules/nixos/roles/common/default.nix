{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.roles.common;
in
{
  options.roles.common = with types; {
    enable = mkBoolOpt false "common nixos configuration.";
  };

  config = mkIf cfg.enable {
      system = {
        ${namespace} = {
          nix.enable = true;
          networking.enable = true;
          locale.enable = true;
          boot.enable = true;
        };
      };
      services = {
        ${namespace} = {
          ssh.enable = true;
          tailscale.enable = true;
          # comin.enable = true;
        };
      };
      styles.stylix.enable = true;
    };
  }
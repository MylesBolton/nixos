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
  cfg = config.roles.common;
in
{
  options.roles.common = with types; {
    enable = mkBoolOpt false "common nixos configuration.";
  };

  config = mkIf cfg.enable {
      system = {
        custom = {
          nix.enable = true;
          networking.enable = true;
          locale.enable = true;
          boot.enable = true;
        };
      };
      services = {
        custom = {
          ssh.enable = true;
          tailscale.enable = true;
        };
      };
      styles.stylix.enable = true;
    };
  }
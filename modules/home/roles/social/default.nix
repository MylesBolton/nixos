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
  cfg = config.roles.social;
in
{
  options.roles.social = with types; {
    enable = mkBoolOpt false "enable social role";
  };

  config = mkIf cfg.enable {
    apps.discord.enable = true;
    home.packages = with pkgs; [signal-desktop];
  };
}
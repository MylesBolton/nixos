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
  cfg = config.custom.roles.social;
in
{
  options.custom.roles.social = with types; {
    enable = mkBoolOpt false "enable social role";
  };

  config = mkIf cfg.enable {
    custom.apps.discord.enable = true;
    home.packages = with pkgs; [
      signal-desktop
      element-desktop
      karere
    ];
  };
}

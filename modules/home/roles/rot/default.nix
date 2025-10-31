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
  cfg = config.roles.rot;
in
{
  options.roles.rot = with types; {
    enable = mkBoolOpt false "enable office role";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      netflix
      #jellyflix
      spotify
      spotify-tray
      fx-cast-bridge
    ];
  };
}

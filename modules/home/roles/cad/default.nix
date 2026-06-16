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
  cfg = config.custom.roles.cad;
in
{
  options.custom.roles.cad = with types; {
    enable = mkBoolOpt false "enable cad role";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      orca-slicer
      openscad
      freecad
      librecad
      #librepcb
      kicad
    ];
  };
}

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
  cfg = config.custom.roles.office;
in
{
  options.custom.roles.office = with types; {
    enable = mkBoolOpt false "enable office role";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nextcloud-client
      libreoffice
      teams-for-linux
      obsidian
      glabels-qt
      ptouch-driver
      anki-bin
      gpa
    ];
  };
}

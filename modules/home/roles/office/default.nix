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
  cfg = config.roles.office;
in
{
  options.roles.office = with types; {
    enable = mkBoolOpt false "enable office role";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nextcloud-client
      calibre
      libreoffice
      logseq
      obsidian
      okular
    ];
  };
}
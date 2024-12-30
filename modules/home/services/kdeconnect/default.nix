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
  cfg = config.services.${namespace}.kdeconnect;
in {
  options.services.${namespace}.kdeconnect = with types; {
    enable = mkBoolOpt false "Whether or not to manage kdeconnect";
  };

  config = mkIf cfg.enable {
    xdg.desktopEntries = {
      "org.kde.kdeconnect.sms" = {
        exec = "";
        name = "KDE Connect SMS";
        settings.NoDisplay = "true";
      };
      "org.kde.kdeconnect.nonplasma" = {
        exec = "";
        name = "KDE Connect Indicator";
        settings.NoDisplay = "true";
      };
      "org.kde.kdeconnect.app" = {
        exec = "";
        name = "KDE Connect";
        settings.NoDisplay = "true";
      };
    };
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}

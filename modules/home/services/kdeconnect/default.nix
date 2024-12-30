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
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}

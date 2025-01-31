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
  cfg = config.services.custom.kdeconnect;
in {
  options.services.custom.kdeconnect = with types; {
    enable = mkBoolOpt false "Whether or not to manage kdeconnect";
  };

  config = mkIf cfg.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}

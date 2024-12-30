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
  cfg = config.services.${namespace}.syncthing;
in {
  options.services.${namespace}.syncthing = {
    enable = mkEnableOption "Enable syncthing service";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray.enable = true;
      extraOptions = ["--gui-address=127.0.0.1:8384"];
    };
  };
}

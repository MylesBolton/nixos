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
  cfg = config.system.${namespace}.bluetooth;
in
{
  options.system.${namespace}.bluetooth = with types; {
    enable = mkBoolOpt false "Enable bluetooth";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}
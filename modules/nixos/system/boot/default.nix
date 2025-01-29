{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.system.${namespace}.boot;
in
{
  options.system.${namespace}.boot = with types; {
    enable = mkBoolOpt false "Whether or not to enable booting.";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 8;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
  };
}
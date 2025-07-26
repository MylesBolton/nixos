{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.custom.services.avahi;
in
{
  options.custom.services.avahi = {
    enable = mkEnableOption "Enable The Avahi service";
  };

  config = mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}

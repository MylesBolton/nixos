{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.system.battery;
in
{
  options.custom.system.battery = with types; {
    enable = mkBoolOpt false "Whether or not to enable battery optimizations and utils.";
  };

  config = mkIf cfg.enable {
    # Better scheduling for CPU cycles - thanks System76!!!
    services.system76-scheduler.settings.cfsProfiles.enable = true;

    # Enable TLP (better than gnomes internal power manager)
    services.tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        USB_AUTOSUSPEND = 0;
        AHCI_RUNTIME_PM_ON_AC = 1;
        USB_EXLUDE_PHONE = 1;      
        };
    };

    # Disable GNOMEs power management
    services.power-profiles-daemon.enable = false;

    # Enable powertop
    powerManagement.powertop.enable = true;

    # Enable thermald (only necessary if on Intel CPUs)
    services.thermald.enable = true;
  };
}
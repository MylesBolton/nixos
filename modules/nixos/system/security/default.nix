{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.system.security;
in
{
  options.custom.system.security = {
    enable = mkEnableOption "Enable security hardening";
    usbguard = mkBoolOpt false "Enable USBGuard to block unauthorized USB devices";
  };

  config = mkIf cfg.enable {
    # Fail2ban for SSH and other services
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [
        "127.0.0.1/8"
        "192.168.1.0/24"
      ];
    };

    # USBGuard protection
    services.usbguard = mkIf cfg.usbguard {
      enable = true;
      dbus.enable = true;
      implicitPolicyTarget = "block";
      # Basic rule to allow already connected devices (risky but better than nothing for a start)
      # User should ideally generate a policy with `usbguard generate-policy`
      rules = ''
        allow with-interface equals { 08:*:* } # Storage
        allow with-interface equals { 03:01:* } # Keyboard
        allow with-interface equals { 03:00:* } # Mouse
      '';
    };

    # AppArmor
    security.apparmor = {
      enable = true;
      enableCache = true;
      killUnconfinedConfinables = true;
    };

    # Kernel hardening
    boot.kernel.sysctl = {
      # Hide kptrs
      "kernel.kptr_restrict" = 1;

      # Restrict dmesg
      "kernel.dmesg_restrict" = 1;

      # Restrict ptrace
      "kernel.yama.ptrace_scope" = 1;

      # Reverse path filtering
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;

      # Ignore ICMP redirects
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;

      # Do not send ICMP redirects
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
    };

    # Disable SUID for some binaries if possible, but might be too aggressive
    # security.sudo.execWheelOnly = true;
  };
}

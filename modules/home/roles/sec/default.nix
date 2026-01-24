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
  cfg = config.roles.sec;
in
{
  options.roles.sec = {
    enable = mkBoolOpt false "Enable the cybersecurity tools role.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      aircrack-ng
      arping
      #armitage
      bettercap
      binwalk
      burpsuite
      certgraph
      crunch
      cyberchef
      deepsecrets
      dnsenum
      enum4linux-ng
      exploitdb
      fcrackzip
      ghidra-bin
      ghorg
      gobuster
      gotestwaf
      hashcat
      hcxdumptool
      hcxtools
      hping
      iaito
      john
      ldapnomnom
      metasploit
      mimikatz
      msldapdump
      nikto
      nmap
      onesixtyone
      p0f
      radare2
      smap
      sleuthkit
      sqlmap
      sslscan
      tcpdump
      testssl
      thc-hydra
      theharvester
      wifite2
      wireshark
      zap
      zenmap
    ];
  };
}

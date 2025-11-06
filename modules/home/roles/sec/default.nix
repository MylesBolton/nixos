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
      burpsuite
      nmap
      zenmap
      smap
      wireshark-cli
      tcpdump
      aircrack-ng
      bettercap
      hping
      gotestwaf
      sqlmap
      gobuster
      metasploit
      armitage
      thc-hydra
      hydra-cli
      mimikatz
      hashcat
      ghidra-bin
      radare2
      iaito
      binwalk
      sleuthkit
      cyberchef
      exploitdb
    ];
  };
}

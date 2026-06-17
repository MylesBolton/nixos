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
  cfg = config.custom.roles.common;
in
{
  options.custom.roles.common = with types; {
    enable = mkBoolOpt false "common nixos configuration.";
  };

  config = mkIf cfg.enable {
  custom = {
    system = {
      nix.enable = true;
      nix-ld.enable = true;
      networking.enable = true;
      locale.enable = true;
      boot.enable = true;
      zram.enable = true;
      security.enable = true;
      oom.enable = true;
    };
    services = {
      openssh.enable = true;
      fwupd.enable = true;
      agenix.enable = true;
    };
    user = {
      name = "user";
      initialPassword = "1337";
    };
  };

    fonts = {
      packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
      enableDefaultPackages = true;
    };
    environment.systemPackages = with pkgs; [
      util-linux
      inetutils
      gopass
      gnupg
      git
      unrar
      unzip
      zip
      btop
      pciutils
      lsscsi
      wget
      curl
      nmap
      lshw
      lsscsi
      libva-utils
      usbutils
      nh
      nix-output-monitor
      nvd
      fastfetch
      fd
      ripgrep
      fzf
    ];
    custom.styles.stylix.enable = true;
  };
}

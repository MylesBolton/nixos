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
  cfg = config.custom.system.nix;
in
{
  options.custom.system.nix = with types; {
    enable = mkBoolOpt false "Whether or not to manage nix configuration";
  };

  config = mkIf cfg.enable {
    
    home.packages = with pkgs; [
      nix-output-monitor
      nvd
    ];

    systemd.user.startServices = "sd-switch";

    programs = {
      home-manager.enable = true;
    };

    nix = {
      settings = {
        experimental-features = ["nix-command" "flakes"];
        warn-dirty = false;
        use-xdg-base-directories = true;
      };
    };

    news = {
      display = "silent";
      json = lib.mkForce {};
      entries = lib.mkForce [];
    };
  };
}


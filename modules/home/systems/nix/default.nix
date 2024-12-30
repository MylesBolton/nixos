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
  cfg = config.system.${namespace}.nix;
in
{
  options.system.${namespace}.nix = with types; {
    enable = mkBoolOpt false "Whether or not to manage nix configuration";
  };

  config = mkIf cfg.enable {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    home.packages = with pkgs; [ ];

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


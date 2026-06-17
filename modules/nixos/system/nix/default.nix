inputs@{
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
    enable = mkBoolOpt false "Whether or not to manage nix stuff.";
  };
  config = mkIf cfg.enable {
    nix = {
      settings = {
        trusted-users = [
          "@wheel"
          "root"
        ];
        auto-optimise-store = lib.mkDefault true;
        use-xdg-base-directories = true;
        experimental-features = [
          "nix-command"
          "flakes"
          "auto-allocate-uids"
          "cgroups"
        ];
        warn-dirty = false;
        system-features = [
          "kvm"
          "big-parallel"
          "nixos-test"
        ];
        builders-use-substitutes = true;
        connect-timeout = 5;
        stalled-download-timeout = 90;
        http-connections = 50;
        max-jobs = "auto";
        cores = 0;
        flake-registry = "";
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://cache.garnix.io"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      
      optimise = {
        automatic = true;
        dates = [ "weekly" ];
      };

      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };

    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/user/git/nixos";
    };

    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "65536";
      }
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "1048576";
      }
    ];
  };
}

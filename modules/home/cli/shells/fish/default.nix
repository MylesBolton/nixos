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
  inherit (config.lib.stylix) colors;
  cfg = config.cli.shells.fish;
in {
  options.cli.shells.fish = with types; {
    enable = mkBoolOpt false "enable fish shell";
  };

  config = mkIf cfg.enable {
    stylix.targets.fish.enable = true;
    programs.fish = {
      enable = true;

      shellAbbrs = {
        #tailscale
        tsu = "tailscale up";
        tsd = "tailscale down";
        tss = "tailscale status";
      };

      functions = { };

      plugins = [
        {
          name = "bass";
          inherit (pkgs.fishPlugins.bass) src;
        }
        {
          name = "sponge";
          inherit (pkgs.fishPlugins.sponge) src;
        }
        {
          name = "tide";
          inherit (pkgs.fishPlugins.tide) src;
        }
        {
          name = "nvm";
          inherit (pkgs.fishPlugins.nvm) src;
        }
      ];
    };
  };
}


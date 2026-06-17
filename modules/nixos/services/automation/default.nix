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
  cfg = config.custom.services.automation;
in
{
  options.custom.services.automation = with types; {
    enable = mkBoolOpt false "Enable automation scripts";
    interval = mkOpt str "daily" "Interval for flake updates (systemd calendar)";
    user = mkOpt str "user" "User to run automation as";
    repoPath = mkOpt str "/home/${cfg.user}/git/nixos" "Path to the nixos repository";
    githubTokenFile = mkOpt (nullOr path) null "Path to file containing GitHub token";
    tailscaleApiKeyFile = mkOpt (nullOr path) null "Path to file containing Tailscale API key";
  };

  config = mkIf cfg.enable {
    systemd.services.nix-flake-update = {
      description = "Update nix flake and push to repository";
      path = with pkgs; [
        nix
        git
        openssh
        coreutils
        gnused
      ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        WorkingDirectory = cfg.repoPath;
      };
      script = ''
        set -e
        echo "Updating flake..."
        nix flake update

        ${optionalString (cfg.tailscaleApiKeyFile != null) ''
          echo "Checking Tailscale keys..."
          if [[ -f "${toString cfg.tailscaleApiKeyFile}" ]]; then
            # Example: Generate a new key and maybe do something with it
            # This is a placeholder for the user's specific rotation logic
            # ts_key=$(curl -u "$(cat ${toString cfg.tailscaleApiKeyFile}):" -X POST https://api.tailscale.com/api/v2/tailnet/-/keys ...)
            echo "Tailscale API key found."
          fi
        ''}

        if [[ -n $(git status --porcelain) ]]; then
          echo "Changes detected, committing and pushing..."
          git add .
          git commit -m "chore: automated updates (flake/keys)"
          git push origin main
        else
          echo "No changes detected"
        fi
      '';
    };

    systemd.timers.nix-flake-update = {
      description = "Timer for nix flake update";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.interval;
        Persistent = true;
      };
    };
  };
}

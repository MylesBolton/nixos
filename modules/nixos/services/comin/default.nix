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
  cfg = config.custom.services.comin;
in
{
  options.custom.services.comin = with types; {
    enable = mkBoolOpt false "Whether or not to enable comin.";
    repo = mkOpt str "https://github.com/MylesBolton/nixos.git" "The repository to pull from.";
    branch = mkOpt str "main" "The branch to pull from.";
    pollPeriod = mkOpt int 1200 "The polling period in seconds.";
  };

  config = mkIf cfg.enable {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = cfg.repo;
          branches.main.name = cfg.branch;
          poller.period = cfg.pollPeriod;
        }
      ];
    };
  };
}

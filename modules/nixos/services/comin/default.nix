{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.services.${namespace}.comin;
in
{
  options.services.${namespace}.comin = with types; {
    enable = {
      enable = mkBoolOpt false "Whether or not to enable automatic updates with comin";
      repo = mkOpt str "" "The git repo url";
      key = mkOpt str "" "The git API key to use";
    };
  };

  config = mkIf cfg.enable {
#            services.comin = {
#              enable = true;
#              remotes = [{
#                name = "origin";
#                url = "https://gitlab.com/your/infra.git";
#                branches.main.name = "main";
#              }];
#            };
  };
}
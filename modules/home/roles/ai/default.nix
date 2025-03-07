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
  cfg = config.roles.ai;
in
{
  options.roles.ai = with types; {
    enable = mkBoolOpt false "Enable AI role";
  };

  config = mkIf cfg.enable {
    services.custom.ollama.enable = true;
  };
}

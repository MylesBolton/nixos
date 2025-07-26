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
  cfg = config.custom.services.ollama;
in
{
  options.custom.services.ollama = with types; {
    enable = mkBoolOpt false "Whether or not to setup ollama";
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
    };
  };
}

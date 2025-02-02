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
  cfg = config.roles.dev;
in
{
  options.roles.dev = with types; {
    enable = mkBoolOpt false "enable dev role";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vscode
      nixfmt-rfc-style
    ];
  };
}
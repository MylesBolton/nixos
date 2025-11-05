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
    apps.vscode.enable = true;
    home.packages = with pkgs; [
      xpipe
      nixfmt-rfc-style
      nil
      typescript
      typescript-language-server
      tailwindcss
      bun
      scanmem
      gemini-cli
    ];
  };
}

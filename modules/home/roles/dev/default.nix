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
  cfg = config.custom.roles.dev;
in
{
  options.custom.roles.dev = with types; {
    enable = mkBoolOpt false "enable dev role";
  };

  config = mkIf cfg.enable {
    custom.apps.vscode.enable = true;
    home.packages = with pkgs; [
      xpipe
      nixfmt
      nil
      typescript
      typescript-language-server
      tailwindcss
      bun
      scanmem
      mcp-nixos
      direnv
      gh
      google-antigravity-cli
    ];
  };
}

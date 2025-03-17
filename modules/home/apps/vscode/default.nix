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
  cfg = config.apps.vscode;
in
{
  options.apps.vscode = {
    enable = mkEnableOption "enable vscode";
  };

  config = mkIf cfg.enable {
    stylix.targets.vscode.profileNames = ["default"];
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          alefragnani.project-manager
          ms-azuretools.vscode-docker
          esbenp.prettier-vscode
          signageos.signageos-vscode-sops
          bbenoist.nix
          jnoortheen.nix-ide
          github.vscode-github-actions
          brettm12345.nixfmt-vscode
        ];
        userSettings = {
          editor.formatOnSave = true;
          editor.formatOnPaste = true;
          git.autofetch = true;
          git.enableSmartCommit = true;
          workbench.iconTheme = "catppuccin-mocha";
          terminal.integrated.defaultProfile.linux = "fish";
          nix.serverPath = "nil";
          nix.formatterPath = "nixfmt";
        };
        keybindings = [
          {
            key = "ctrl+shift+'";
            command = "workbench.action.terminal.new";
            when = "terminalProcessSupported || terminalWebExtensionContributedProfile";
          }
        ];
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
      };
    };
  };
}

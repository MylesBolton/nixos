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
    #stylix.targets.vscode.profileNames = ["default"];
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
          "editor" = {
            "formatOnPaste" = true;
            "formatOnSave" = true;
          };
          "git" = {
            "autofetch" = true;
            "enableSmartCommit" = true;
          };
          "workbench" = {
            "iconTheme" = "catppuccin-mocha";
          };
          "terminal" = {
            "integrated" = {
              "defaultProfile" = {
                "linux" = "fish";
              };
            };
          };
          "nix" = {
            "formatterPath" = "nixfmt";
            "serverPath" = "nil";
          };
          "projectManager.git.baseFolders" = [ "/home/user/git" ];
          "[nix]" = {
            "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
          };
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

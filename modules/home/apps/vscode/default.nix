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
        extensions = with pkgs.vscode-marketplace; [
          mkhl.direnv
          alefragnani.project-manager
          ms-azuretools.vscode-docker
          esbenp.prettier-vscode
          signageos.signageos-vscode-sops
          bbenoist.nix
          jnoortheen.nix-ide
          github.vscode-github-actions
          brettm12345.nixfmt-vscode
          bradlc.vscode-tailwindcss
          dbaeumer.vscode-eslint
          tailscale.vscode-tailscale
          ms-vscode-remote.remote-containers
          ms-vscode-remote.remote-ssh
          google.gemini-cli-vscode-ide-companion
        ];
        userSettings = {
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "git.autofetch" = true;
          "git.enableSmartCommit" = true;
          "git.confirmSync" = false;
          "terminal.integrated.defaultProfile.linux" = "fish";
          "nix.formatterPath" = "nixfmt";
          "nix.serverPath" = "nil";
          "geminicodeassist.project" = "radiant-wall-473314-m8";
          "projectManager.git.baseFolders" = [ "~/git" ];
          "[nix]" = {
            "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
          };
          "[typescriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[typescript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "chat.disableAIFeatures" = true;
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

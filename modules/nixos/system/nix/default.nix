 inputs@{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.system.${namespace}.nix;
in
{
  options.system.${namespace}.nix = with types; {
    enable = mkBoolOpt false "Whether or not to manage nix stuff.";
  };
  config = mkIf cfg.enable {
    nix = {
      settings = {
        trusted-users = ["@wheel" "root"];
        auto-optimise-store = lib.mkDefault true;
        use-xdg-base-directories = true;
        experimental-features = ["nix-command" "flakes"];
        warn-dirty = false;
        system-features = ["kvm" "big-parallel" "nixos-test"];
      };
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}

{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.services.agenix;
in
{
  options.custom.services.agenix = with types; {
    enable = mkBoolOpt false "Whether or not to enable agenix.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.system}.default
    ];

    age.identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}

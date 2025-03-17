{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.custom.services.virtualisation.podman;
in {
  options.custom.services.virtualisation.podman = {
    enable = mkEnableOption "Enable podman";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerSocket.enable = true;
        dockerCompat = true;
        defaultNetwork.settings = {
          dns_enabled = true;
        };
      };
    };
  };
}

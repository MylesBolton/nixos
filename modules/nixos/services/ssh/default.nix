{
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
  cfg = config.services.${namespace}.ssh;
in
{
  options.services.${namespace}.ssh = with types; {
    enable = mkBoolOpt false "Enable ssh";
  };

  config = mkIf cfg.enable {  
    networking.firewall = {
      allowedTCPPorts = [ 22 ];
    }; 
    services.openssh = {
      enable = true;
      ports = [22];

      settings = {
        PasswordAuthentication = false;
        StreamLocalBindUnlink = "yes";
        GatewayPorts = "clientspecified";
      };
    };
    users.users = {
      ${config.user.name}.openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAlij2lxj8OoCoDNurBmYuRucZ7eGZ65vy0/goCY9mmDAAAAGnNzaDpNeWxlc0JvbHRvbl9CYWNrdXBfU1NI"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEII8saSYun/OtVtCJrPJFjoTaN8XFTMNy9R1giZPcvlAAAAGHNzaDpNeWxlc0JvbHRvbl9NYWluX1NTSA=="
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxQd8uI865VoHU6xa7hU1EOsmNSxlhRYG5Hh26+3i0a user@desktop"
      ];
    };
  };
}
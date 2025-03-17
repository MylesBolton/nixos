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
  cfg = config.custom.services.openssh;
in
{
  options.custom.services.openssh = with types; {
    enable = mkBoolOpt false "Enable ssh";
  };

  config = mkIf cfg.enable {  
    networking.firewall = {
      allowedTCPPorts = [22];
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
      ${config.custom.user.name}.openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAlij2lxj8OoCoDNurBmYuRucZ7eGZ65vy0/goCY9mmDAAAAGnNzaDpNeWxlc0JvbHRvbl9CYWNrdXBfU1NI"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEII8saSYun/OtVtCJrPJFjoTaN8XFTMNy9R1giZPcvlAAAAGHNzaDpNeWxlc0JvbHRvbl9NYWluX1NTSA=="
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPACDqaaOvlWsTXU3yX6JMZGVYGzmSn1r2JWXaQxcLbj"
      ];
    };
  };
}
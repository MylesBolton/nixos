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
  cfg = config.custom.system.nix-ld;
in
{
  options.custom.system.nix-ld = with types; {
    enable = mkBoolOpt false "Whether or not to enable nix-ld for binary compatibility.";
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        fuse3
        icu
        nss
        openssl
        curl
        expat
      ];
    };
  };
}

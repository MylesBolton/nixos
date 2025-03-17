{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.custom.user;
in
{
  options.custom.user = with types; {
    name = mkOpt str "user" "The name of the user's account";
    initialPassword =
      mkOpt str "1337"
      "The initial password to use";
    admin = mkBoolOpt false "is admin";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions =
      mkOpt attrs {}
      "Extra options passed to users.users.<name>";
  };

  config = {
    users.mutableUsers = true;
    snowfallorg.users.${cfg.name}.admin = cfg.admin;
    users.users.${cfg.name} = {
        isNormalUser = true;
        inherit (cfg) name initialPassword;
        home = "/home/${cfg.name}";
        group = "users";

        extraGroups =
          [
            "audio"
            "sound"
            "video"
            "lp"
          ]
          ++ cfg.extraGroups;
      }
      // cfg.extraOptions;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };
  };
}


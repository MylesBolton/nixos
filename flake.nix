{
  description = "MylesBolton's Nix/NixOS Config";
  nixConfig = {
    extra-substituters = "https://nix-community.cachix.org";
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  };
  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    stylix.url = "github:danth/stylix";
    nur.url = "github:nix-community/NUR";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    nixos-anywhere = {
      url = "github:numtide/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
    };
  };

  outputs =
    inputs:

    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          metadata = "custom";
          namespace = "custom";
          meta = {
            name = "custom";
            title = "MylesBolton's custom Nix stuff";
          };
        };
      };

    in
    lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
      };

      overlays = with inputs; [
        nur.overlays.default
        nixgl.overlay
      ];

      systems.modules.nixos = with inputs; [
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
        agenix.nixosModules.default
        comin.nixosModules.comin
        (
          { ... }:
          {
            services.comin = {
              enable = true;
              remotes = [
                {
                  name = "origin";
                  url = "https://github.com/MylesBolton/nixos.git";
                  auth.access_token_path = "/persits/secrets/comin/token";
                  branches.main.name = "main";
                  branches.testing.name = "beta";
                  poller.period = 1200;
                }
              ];
            };
          }
        )
      ];

      outputs-builder = channels: {
        formatter = channels.nixpkgs.nixfmt-rfc-style;
      };

    };
}

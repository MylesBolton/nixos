{
  description = "MylesBolton's Nix/NixOS Config";
  inputs = {
    nixpkgs.url                         = "github:Nixos/nixpkgs";
    nixpkgs-unstable.url                = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url                  = "github:NixOS/nixos-hardware";
    agenix.url                          = "github:ryantm/agenix";
    stylix.url                          = "github:danth/stylix";
    catppuccin.url                      = "github:catppuccin/nix";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
      };
    snowfall-lib = {
      url                               = "github:snowfallorg/lib";
      inputs.nixpkgs.follows            = "nixpkgs";
    };
    disko = {
      url                               = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows            = "nixpkgs";
    };
    home-manager = {
      url                               = "github:nix-community/home-manager";
      inputs.nixpkgs.follows            = "nixpkgs";
    };
    comin = {
      url                               = "github:nlewo/comin";
      inputs.nixpkgs.follows            = "nixpkgs";
    };
  };
  
  outputs = inputs: 
  
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
        permittedInsecurePackages = [
          "electron-27.3.11" # for logseq
        ];
      };

      overlays = with inputs; [ ];

      systems.modules.nixos = with inputs; [ 
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
        comin.nixosModules.comin
        ({...}: {
            services.comin = {
              enable = true;
              remotes = [{
                name = "origin";
                url = "https://github.com/MylesBolton/nixos.git";
                branches.main.name = "main";
              }];
            };
          })
      ];
    };
}
{
  description = "MylesBolton's Nix/NixOS Config";
  inputs = {
    nixpkgs.url                         = "github:Nixos/nixpkgs";
    nixpkgs-unstable.url                = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url                  = "github:NixOS/nixos-hardware";
    agenix.url                          = "github:ryantm/agenix";
    stylix.url                          = "github:danth/stylix";
    catppuccin.url                      = "github:catppuccin/nix";
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
        metadata = "eden";
        namespace = "eden";
        meta = {
          name = "eden";
          title = "MylesBolton's Nix Eden";
        };
      };
    };
  
  in
    lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ ];
      };

      overlays = with inputs; [ ];

      systems.modules.nixos = with inputs; [ 
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
      ];
    };
}
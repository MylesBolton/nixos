{
  description = "MylesBolton's Nix/NixOS Config";
  inputs = {
    nixpkgs.url                         = "github:Nixos/nixpkgs";
    nixpkgs-unstable.url                = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url                  = "github:NixOS/nixos-hardware";
    stylix.url                          = "github:danth/stylix";
    catppuccin.url                      = "github:catppuccin/nix";
    nur.url                             = "github:nix-community/NUR";
    firefox-gnome-theme = {
      url                               = "github:rafaelmardojai/firefox-gnome-theme";
      flake                             = false;
    };
    nixos-generators = {
      url                               = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows            = "nixpkgs";
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
    sops-nix = {
      url                               = "github:mic92/sops-nix";
      inputs.nixpkgs.follows            = "nixpkgs";
    };
    nixos-anywhere = {
      url                               = "github:numtide/nixos-anywhere";
      inputs.nixpkgs.follows            = "nixpkgs";
      inputs.disko.follows              = "disko";
    };
    ghostty = {
      url                               = "github:ghostty-org/ghostty";
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

      overlays = with inputs; [
        nur.overlays.default
       ];

      systems.modules.nixos = with inputs; [ 
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        comin.nixosModules.comin
        ({...}: {
          services.comin = {
          enable = true;
          remotes = [{
            name = "origin";
            url = "https://github.com/MylesBolton/nixos.git";
            #auth.access_token_path = "/filepath/to/your/access/token";
            branches.main.name = "main";
            branches.testing.name = "testing";
            poller.period = 300;
          }];
        };
      })
      ];
    };
}
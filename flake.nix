{
  description = "My nix config";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    nixos-cosmic,
    flake-utils,
    ...
  } : {
    nixosConfigurations = {
      nixos-ga401 = nixpkgs.lib.nixosSystem {
        modules = [
          nixos-hardware.nixosModules.asus-zephyrus-ga401
          ./hosts/ga401
          home-manager.nixosModules.home-manager
          nixos-cosmic.nixosModules.default
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = inputs;
            home-manager.users.itsusinn = import ./home;
            nix.settings.trusted-users = [ "itsusinn" ];
          }
        ];
      };
    };
  };
}

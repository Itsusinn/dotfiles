{
  description = "My nix config";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    hyprland.url = "github:hyprwm/Hyprland";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    hyprland,
    flake-utils,
    ...
  } : {
    nixosConfigurations = {
      nixos-ga401 = nixpkgs.lib.nixosSystem {
        modules = [
          nixos-hardware.nixosModules.asus-zephyrus-ga401
          ./hosts/ga401
          home-manager.nixosModules.home-manager
          {
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

{ inputs, outputs, impurity, ... }: {
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    # enable the usage user packages through
    # the users.users.<name>.packages option
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs impurity;
    };
    users = {
      # Import your home-manager configuration
      itsusinn = import ../home-manager/home.nix;
    };
  };
}
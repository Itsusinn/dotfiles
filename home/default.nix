{ inputs, outputs, impurity, ... }: {
  imports = [
    ./home.nix
    ./theme.nix
    ./dconf.nix
    ./waybar.nix
    ./xfce.nix
  ];
  home = {
    username = "itsusinn";
    homeDirectory = "/home/itsusinn";
    stateVersion = "24.05";
    enableNixpkgsReleaseCheck = true;
  };
  programs.home-manager.enable = true;
}

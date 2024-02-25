# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs,lib,config,pkgs,...}:
{
  imports = [
    ./theme.nix
    ./dconf.nix
    ./waybar.nix
    ./xfce.nix
  ];
  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "itsusinn";
    homeDirectory = "/home/itsusinn";
  };
  home.packages = with pkgs; [
    # shell
    bat # cat
    eza # ls
    # dev
    sqlite
    nodePackages.nodejs
    nodePackages.pnpm
    nodePackages.yarn
    gcc
    gnupg
    zulu8
    rsync
    # apps
    firefox
    spotify
    qq
    vscode
    gitkraken
    obs-studio
    home-manager
    gparted
    jetbrains.idea-ultimate
    android-studio
    rustup
    android-tools
    telegram-desktop
    qbittorrent
    # Desktop
    xdg-desktop-portal-hyprland
    rofi-wayland
    waybar
    cliphist
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update-flake = "cd /home/itsusinn/dotfiles && git add . && sudo nix flake update";
      update = "cd /home/itsusinn/dotfiles && git add . && sudo nixos-rebuild switch --flake .#itsusinn-nixos";
      cat = "bat";
      ls = "eza";
    };
    plugins = [
      { name = "z"; src = pkgs.fishPlugins.z.src; }
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      { name = "git"; src = pkgs.fishPlugins.plugin-git.src; }
    ];
  };

  programs.direnv = {
    enable = true;
    # enableFishIntegration = true;
  };
  programs.neovim.enable = true;
  programs.starship = {
    enable = true;
    settings = {
      # add_newline = false;
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig = "
      monitor=DP-1,2560x1440,auto,1
      monitor=eDP-1,disable
      exec-once = waybar
      exec-once = clash-verge
      exec-once = thunar --daemon
      exec-once = playerctld
      exec-once = wl-paste --type text --watch cliphist store
      env = XCURSOR_SIZE,24
      env = WLR_NO_HARDWARE_CURSORS,1
      $mainMod = SUPER

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, Q, exec, xfce4-terminal
      bind = $mainMod, C, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, thunar
      bind = $mainMod, F, exec, firefox
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, rofi -show drun
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Scroll through existing workspaces with mainMod + scrolls
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
    ";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-configtool
      ];
    };
  };

  systemd.user.startServices = "sd-switch";


  home.stateVersion = "24.05";
  home.enableNixpkgsReleaseCheck = true;
}
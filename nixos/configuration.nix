{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelParams = [ "module_blacklist=amdgpu" ];
  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
    "/swap".options = ["noatime"];
    "/media/game" = {
      device = "/dev/disk/by-uuid/96fcf084-cbcc-d15f-849c-0abcc6bd10b6";
      fsType = "btrfs";
      options = [ "subvol=game" "compress=zstd"];
    };
    "/media/root" = {
      device = "/dev/disk/by-uuid/96fcf084-cbcc-d15f-849c-0abcc6bd10b6";
      fsType = "btrfs";
    };
  };
  swapDevices = [ { device = "/swap/swapfile"; } ];
  networking.hostName = "itsusinn-nixos"; # Define your hostname.
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  networking.proxy.default = "http://127.0.0.1:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    # WTF
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    # WTF
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;

  users.users.itsusinn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio"];
    shell = pkgs.zsh;
    packages = with pkgs; [

    ];
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      fira-code-nerdfont
      source-han-sans
      source-han-serif
      sarasa-gothic
    ];
  };
  environment.systemPackages = with pkgs; [
    git
    wget
    pciutils
    tmux
    kitty
    xdg-desktop-portal-hyprland
    rofi-wayland
    waybar
    dunst
    pavucontrol
    cliphist
    compsize
    # xfce
    xfce.xfce4-terminal
    xfce.xfce4-settings
    xfce.xfce4-taskmanager
    # gtk theme
    glib
    gtk3.out
    gnome.gnome-themes-extra
    gnome.adwaita-icon-theme
  ];
  environment.shellAliases = {
    editnix = "sudo nvim /etc/nixos/configuration.nix";
    edithypr = "nvim ~/.config/hypr/hyprland.conf";
    rebuild = "sudo nixos-rebuild switch";
  };
  programs.zsh = {
    enable = true;
  };
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  system.stateVersion = "23.05";
}


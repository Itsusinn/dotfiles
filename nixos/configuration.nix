{ inputs, config, pkgs, lib, stdenv, ... }: let
  hyprland-session = pkgs.callPackage ./session.nix {};
in
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
    config = {
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
    compsize
  ];

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
  services.xserver = {
    enable = true;
    displayManager = {
      sessionPackages = [hyprland-session];
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };
  programs = {
    # enable hyprland and required options
    hyprland.enable = true;
    # steam.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
    xfconf.enable = true;
    zsh.enable = true;
    clash-verge = {
      enable = true;
      tunMode = true;
      autoStart = false;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "23.05";
}


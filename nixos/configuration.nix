{ inputs, config, pkgs, lib, stdenv, ... }:
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
    config = {
      allowUnfree = true;
    };
  };

  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  networking.proxy.default = "http://127.0.0.1:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;
  i18n.defaultLocale = "zh_CN.UTF-8";
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
      # substituters =  [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
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
    shell = pkgs.fish;
    packages = with pkgs; [];
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      twemoji-color-font
      sarasa-gothic
      jetbrains-mono
      noto-fonts
      noto-fonts-emoji
      fira-code-nerdfont
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [
          "Fira Code Nerd Font Mono"
          "Sarasa Mono SC"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans"
          "Sarasa Gothic SC"
          "Noto Color Emoji"
        ];
        serif = [
          "Noto Serif"
          "Sarasa Gothic SC"
          "Noto Color Emoji"
        ];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    git
    wget
    pciutils
    tmux
    compsize

    #uutils-coreutils-noprefix
    libgcc
  ];
  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  hardware.pulseaudio.enable = false;

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };

  programs = {
    fish.enable = true;
    clash-verge = {
      enable = true;
      tunMode = true;
      autoStart = false;
    };
    xfconf.enable = true;
    dconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "24.05";
}


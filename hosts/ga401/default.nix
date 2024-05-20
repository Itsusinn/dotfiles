{ inputs, config, pkgs, lib, stdenv, ... }: let
  hyprland-session = pkgs.callPackage ./hyprland-session.nix {};
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelPackages = with pkgs.linuxKernel; [packages.linux_zen linuxKernel.packages.linux_zen.perf];
  # boot.kernelParams = [ "module_blacklist=amdgpu" ];
  fileSystems = {
    "/media/game" = {
      device = "/dev/disk/by-uuid/c06e2de3-db2b-4ce9-baa3-8a91b491cf1a";
      fsType = "btrfs";
      options = [ "subvol=game" "compress=zstd"];
    };
    "/media/root" = {
      device = "/dev/disk/by-uuid/c06e2de3-db2b-4ce9-baa3-8a91b491cf1a";
      fsType = "btrfs";
    };
    "/media/mobile" = {
      device = "/dev/disk/by-uuid/14ADC24058EA7528";
      fsType = "ntfs";
    };
  };
  # swapDevices = [ { device = "/swap/swapfile"; } ];
  zramSwap = {
    enable = true;
    memoryPercent = 34;
    algorithm = "zstd";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  };

  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  networking = {
    networkmanager.enable = true;
    hostName = "itsusinn-nixos";
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.nftables.enable = true;
    firewall.enable = false;
    proxy.default = "http://127.0.0.1:7890";
  };

  i18n.defaultLocale = "zh_CN.UTF-8";
  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      substituters =  [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d"; # 士别三日 当刮目相看
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
    config.boot.kernelPackages.perf
    #uutils-coreutils-noprefix
    #libgcc
  ];
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  services.displayManager.sessionPackages = [ hyprland-session ];
  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
  };


  hardware.pulseaudio = {
    enable = false;
  };

  hardware.steam-hardware.enable = true;
  services.gvfs.enable = true;
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };
  # use adb in non-root
  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  programs = {
    fish.enable = true;
    clash-verge = {
      enable = true;
      tunMode = true;
      autoStart = false;
      package = pkgs.clash-nyanpasu;
    };
    xfconf.enable = true;
    dconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      gamescopeSession = {
        enable = true;
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

  system.stateVersion = "24.05";
}


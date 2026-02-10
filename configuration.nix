{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.limine = {
    enable = true;
    secureBoot.enable = true;
    maxGenerations = 3;
    extraEntries = ''
      /Windows 10
        protocol: efi
        path: guid(67e71716-fe61-466c-b397-8fdf563e3251):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
    extraConfig = ''
      default_entry=1
    '';
    style = {
      wallpapers = [ ];
      interface = {
        resolution = "2560x1440";
        helpHidden = true;
        branding = "blackbox";
        brandingColor = 6;
      };
    };
  };


  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [ kdePackages.fcitx5-chinese-addons ];
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # COSMIC Desktop Environment.
  # services.displayManager.cosmic-greeter.enable = true;
  # services.desktopManager.cosmic.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.ihsin = {
    isNormalUser = true;
    shell = pkgs.nushell;
    description = "iHsin";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.firefox.enable = true;
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    tunMode = true;
    serviceMode = true;
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    just
    rustdesk-flutter
    sbctl # security boot
    rustup
  ];
  environment.variables.EDITOR = "nvim";

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      sarasa-gothic
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "Sarasa Mono SC" ];
        sansSerif = [ "Noto Sans CJK SC" "Sarasa Gothic SC" ];
        serif = [ "Noto Serif CJK SC" "Sarasa Gothic SC" ];
        emoji = [ "Noto Color Emoji" ];
      };
      enable = true;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 30;
  };
  # FAKE AS WINDOWS
  boot.kernel.sysctl = {
    # IPv4相关
    "net.ipv4.ip_default_ttl" = 128;
    "net.ipv4.tcp_syn_retries" = 5;
    # IPv6相关
    "net.ipv6.conf.all.hop_limit" = 128;
    "net.ipv6.conf.default.hop_limit" = 128;
  };
  networking.hostName = "iHsin-Blackbox";
  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
  };
  networking.dhcpcd.extraConfig = ''
    vendorclassid "MSFT 5.0"
    msuserclass "MSFT 5.0"
  '';

  system.stateVersion = "25.11";
}

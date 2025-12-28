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
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
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

  networking.firewall.enable = false;

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
  networking.hostName = "DESKTOP-ABC1234";
  networking.firewall.extraCommands = ''
    # 修改所有出站TCP包的TTL
    iptables -t mangle -A POSTROUTING -p tcp -j TTL --ttl-set 128
    iptables -t mangle -A POSTROUTING -p udp -j TTL --ttl-set 128
    iptables -t mangle -A POSTROUTING -p icmp -j TTL --ttl-set 128
    
    # IPv6
    ip6tables -t mangle -A POSTROUTING -p tcp -j HL --hl-set 128
    ip6tables -t mangle -A POSTROUTING -p udp -j HL --hl-set 128
    ip6tables -t mangle -A POSTROUTING -p ipv6-icmp -j HL --hl-set 128
  '';

  networking.firewall.extraStopCommands = ''
    iptables -t mangle -F POSTROUTING 2>/dev/null || true
    ip6tables -t mangle -F POSTROUTING 2>/dev/null || true
  '';
  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
  };
  # 4. DHCP配置 - Windows vendor标识
  networking.dhcpcd.extraConfig = ''
    hostname DESKTOP-WIN10PC
    clientid
    vendor MSFT 5.0
    # 发送Windows特有的DHCP选项
    option classless_static_routes
    option ms_classless_static_routes
  '';
  # 5. 禁用可能暴露Linux身份的服务
  services.avahi.enable = false;  # mDNS可能暴露Linux
  
  system.stateVersion = "25.11";
}

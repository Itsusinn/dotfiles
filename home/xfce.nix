{ inputs,lib,config,pkgs,...}:
{
    home.packages = with pkgs; [
        xfce.xfce4-terminal
        xfce.xfce4-settings
        xfce.xfce4-taskmanager
        xfce.exo
        xfce.xfce4-volumed-pulse
        xfce.xfce4-icon-theme
        font-manager
        polkit_gnome
        pavucontrol
        networkmanagerapplet
    ];
}
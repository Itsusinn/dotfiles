{ inputs, pkgs, ... }:
{
    xdg.configFile."waybar/macchiato.css".text = builtins.readFile ./config/waybar/macchiato.css;
    programs.waybar = {
        enable = true;
        style = builtins.readFile ./config/waybar/style.css;
        settings = {
            mainBar = {
                layer = "top";
                position = "top";
                height = 16;
                # width = 16;
                # spacing = 4;
                modules-left = [
                    "hyprland/workspaces"
                ];
                modules-center = [
                    # "mpris"
                    "cpu"
                    "memory"
                    "temperature"
                    "clock"
                ];
                modules-right = [
                    "tray"
                    "pulseaudio"
                    "network"
                ];
                "hyprland/workspaces" = {
                    active-only = false;
                    all-outputs = true;
                    format = "{icon}";
                    format-icons = {
                        default = "";
                    };
                };


                cpu = {
                    format = "  ";
                };
                memory = {
                    format = "  ";
                };
                temperature = {
                    format = "  ";
                };

                pluseaudio = {
                    format = "  ";
                    format-muted = "  ";
                    format-source = "  ";
                    # on-click = "pavucontrol";
                };
                tray = {
                    icon-size = 18;
                    spacing = 10;
                };
                network = {
                    format-wifi = "  ";
                    format-disconnected = " X ";
                    format-ethernet = "  ";
                    tooltip = true;
                    tooltip-format = "{signalStrength}%";
                };
            };
        };
    };
}
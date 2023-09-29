{
  lib,
  stdenv,
  pkgs,
  ...
}: let
  hyprland = ''
    [Desktop Entry]
    Name=Hyprland
    Comment=highly customizable dynamic tiling Wayland compositor
    Exec=Hyprland
    Type=Application
  '';
in
  stdenv.mkDerivation rec {
    installPhase = ''
      mkdir -p $out/share/wayland-sessions
      echo "${hyprland}" > $out/share/wayland-sessions/hyprland.desktop
    '';
  }
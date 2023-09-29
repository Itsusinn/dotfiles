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
    name = "hyprland-session";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/wayland-sessions
      echo "${hyprland}" > $out/share/wayland-sessions/hyprland.desktop
    '';
    passthru.providedSessions = ["hyprland"];
  }
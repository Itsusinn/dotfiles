let
  pkgs = import <nixpkgs> { };

  libraries = with pkgs;[
    llvmPackages_11.libcxxStdenv
    llvmPackages_11.libraries.libcxx
    llvmPackages_11.libraries.libcxxabi
    llvmPackages_11.libclang.lib
    ncurses
    pkg-config
  ];

in
pkgs.mkShell {
  buildInputs = libraries;

  shellHook =
    ''
      export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
    '';
}
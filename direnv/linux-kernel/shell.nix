let
  pkgs = import <nixpkgs> { };

  libraries = with pkgs;[
    llvmPackages.libcxxStdenv
    llvmPackages.libraries.libcxx
    llvmPackages.libraries.libcxxabi
    llvmPackages.libclang.lib
    ncurses
    pkg-config
    flex
    bison
  ];

in
pkgs.mkShell {
  buildInputs = libraries;

  shellHook =
    ''
      export PKG_CONFIG_PATH="${pkgs.ncurses.dev}/lib/pkgconfig"
      export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
    '';
}
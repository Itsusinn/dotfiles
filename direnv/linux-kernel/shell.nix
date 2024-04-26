let
  pkgs = import <nixpkgs> { };

  libraries = with pkgs;[
    llvmPackages.libcxxStdenv
    llvmPackages.libclang.lib
    llvmPackages.lld
    llvmPackages.libllvm
    elfutils
    bc
    ncurses
    pkg-config
    flex
    bison
    openssl.dev
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
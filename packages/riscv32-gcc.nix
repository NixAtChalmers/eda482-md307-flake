{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glib,
  gtk3,
  libx11,
  libxxf86vm,
  libsm,
  libxkbcommon,
  cairo,
  gdk-pixbuf,
  pango,
  fontconfig,
  libusb1,
  ...
}:
stdenv.mkDerivation rec {
  pname = "riscv32-gcc";
  version = "0-unstable-2026-01-20";

  src = fetchurl {
    url = "https://www.cse.chalmers.se/edu/resources/software/riscv32-gcc/riscv-gcc-ubuntu-22.04-x64.tar.gz";
    sha256 = "sha256-uPTXT4w2D6pXjoMBPDfBOidAhqnm/fcTnBeKGg4lsuM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    glib
    gtk3
    libx11
    libxxf86vm
    libsm
    libxkbcommon
    cairo
    gdk-pixbuf
    pango
    fontconfig
    libusb1
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out
    cp -R . $out/
  '';

  postFixup = ''
    rm -f $out/bin/clang*
    rm -f $out/bin/riscv32-unknown-elf-clang*
  '';

  meta = with lib; {
    homepage = "https://www.cse.chalmers.se/edu/resources/software/riscv32-gcc";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = [];
  };
}

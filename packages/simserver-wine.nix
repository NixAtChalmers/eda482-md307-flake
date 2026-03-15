{
  stdenv,
  lib,
  pkgs,
  fetchurl,
  makeDesktopItem,
  winePackages,
  ...
}: let
  ref = "75f2ccc323a3f7e59476e43dbe50d6e5a86b2ebd";

  wrapWine = (import (fetchurl {
    url = "https://raw.githubusercontent.com/lucasew/nixcfg/842cbec77d374ceb2b67c70795f7a6f3a99c563d/nix/pkgs/wrapWine.nix";
    sha256 = "sha256-qSppxfSSdtqRuDOysHVNGc0TE1lxUw6kNifci2RU7rY=";
  })) {inherit pkgs;};

  wine = winePackages.waylandFull;

  desktopItem = makeDesktopItem {
    name = "simserver-wine";
    desktopName = "Simserver (Wine)";
    icon = "simserver";
    exec = "simserver-wine";
  };
in
  stdenv.mkDerivation rec {
    pname = "simserver-wine";
    version = "0-unstable-2026-02-25";

    src = wrapWine {
      inherit wine;
      name = "simserver-wine";
      executable = "/home/oli/Downloads/simserver.exe";
      wineFlags = "explorer /desktop=name,1920x1080";
      tricks = [
        "comctl32ocx"
        "vb6run"
      ];
    };

    propagatedBuildInputs = [wine];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp -R $src/bin/* $out/bin/
      install -m 444 -D "${desktopItem}/share/applications/"* \
        -t $out/share/applications/

      runHook postInstall
    '';

    meta = with lib; {
      description = "Simserver for the MD307 lab computer, running in Wine.";
      homepage = "https://git.chalmers.se/erik.sintorn/mdx07-binaries";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
      maintainers = [];
    };
  }

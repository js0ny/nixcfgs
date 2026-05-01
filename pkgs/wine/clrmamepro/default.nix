{
  pkgs,
  winepkg ? pkgs.wine64,
  ...
}:
let
  version = "0.6.3";
in
pkgs.stdenv.mkDerivation {
  pname = "clrmamepro";
  version = version;

  src = pkgs.fetchurl {
    url = "https://mamedev.emulab.it/clrmamepro/binaries/clrmame_v063.zip";
    sha256 = "sha256-RyV21K8ofj2SG8VKin9Ap76+1Eb2VBTR1T2Ivkz7LWA=";
  };

  nativeBuildInputs = [
    pkgs.unzip
    pkgs.makeWrapper
  ];

  buildInputs = [ winepkg ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/opt/clrmamepro
    cp -r * $out/opt/clrmamepro/

    mkdir -p $out/bin

    makeWrapper lib.getExe winepkg $out/bin/clrmameUI \
      --add-flags "$out/opt/clrmamepro/clrmameUI.exe"

    makeWrapper lib.getExe winepkg $out/bin/clrmame \
      --add-flags "$out/opt/clrmamepro/clrmame.exe"
  '';
}

{ pkgs, ... }:

let
  sources = pkgs.callPackage ../../_sources/generated.nix { };
  p = sources.rime_wanxiang_flypy;
in
pkgs.stdenv.mkDerivation {
  pname = "rime-wanxiang-flypy";
  inherit (p) version src;

  nativeBuildInputs = [ pkgs.unzip ];

  sourceRoot = ".";

  unpackPhase = ''
    unzip $src -d .
  '';

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';
}

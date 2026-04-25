{
  stdenv,
  lib,
  callPackage,
}:
let
  sources = callPackage ../../_sources/generated.nix { };
  p = sources.dwproton-linux-x64;
in
stdenv.mkDerivation {
  pname = "dwproton";
  inherit (p) version src;

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';

  meta = with lib; {
    description = "Proton builds with the latest Dawn Winery fixes, optimised for Asian Gacha games";
    homepage = "https://dawn.wine/dawn-winery/dwproton";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    # maintainers = with maintainers; [ ];
  };
}

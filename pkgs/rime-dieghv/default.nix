{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fd,
}:
stdenvNoCC.mkDerivation {
  pname = "rime-teochew";
  version = "1709bb786a144de7be2229755011fde9034457de";

  src = fetchFromGitHub {
    owner = "kahaani";
    repo = "dieghv";
    rev = "1709bb786a144de7be2229755011fde9034457de";
    hash = "sha256-rMViEO0nxNEjVZbHwB0e9vSpe5TfHV7CuJoouS84Pjg=";
  };

  nativeBuildInputs = [ fd ];

  postPatch = ''
    fd -e md -t f -X rm
  '';

  installPhase = ''
    mkdir -p $out
    cp -r . $out
  '';
}

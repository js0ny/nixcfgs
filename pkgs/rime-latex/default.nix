{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fd,
}:
stdenvNoCC.mkDerivation {
  pname = "rime-latex";
  version = "858f2abc645f0e459e468e98122470ce20b16b30";

  src = fetchFromGitHub {
    owner = "shenlebantongying";
    repo = "rime_latex";
    rev = "858f2abc645f0e459e468e98122470ce20b16b30";
    hash = "sha256-i8Rgze+tQhbE+nl+JSj09ILXeUvf6MOS9Eqsuqis1n0=";
  };

  nativeBuildInputs = [ fd ];

  postPatch = ''
    fd -e md -t f -X rm
    rm -rf .scripts
    rm -f LICENSE
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r . $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rime input method schema for LaTeX";
    homepage = "https://github.com/shenlebantongying/rime_latex";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}

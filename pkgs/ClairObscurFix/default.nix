{
  fetchzip,
  stdenvNoCC,
  ...
}:
let
  version = "0.0.15";
in
stdenvNoCC.mkDerivation {
  pname = "ClairObscurFix";
  version = version;

  src = fetchzip {
    url = "https://codeberg.org/Lyall/ClairObscurFix/releases/download/${version}/ClairObscurFix_${version}.zip";
    sha256 = "sha256-lJV+ujiSx/IkjLG5UcA54+3ucNscV2KBwOYnIlUMM2s=";
    stripRoot = false;
  };

  postPatch = /* bash */ ''
    mv ClairObscurFix.ini ClairObscurFix.ini.example
  '';

  installPhase = ''
    mkdir -p $out
    cp -r . $out
  '';
}

{
  stdenvNoCC,
  fetchFromGitHub,
  fd,
}:
stdenvNoCC.mkDerivation {
  pname = "rime-cantonese";
  version = "69615390ccb65736186f5cb76b32bed365fd18ed";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "rime-cantonese";
    rev = "69615390ccb65736186f5cb76b32bed365fd18ed";
    hash = "sha256-vkE+kag5ZXwJwlGBWCTDZkP00h4/XwanpK1aChj+S2o=";
  };

  nativeBuildInputs = [ fd ];

  postPatch = ''
    fd -e md -t f -X rm
    rm -rf .ci .github demo
  '';

  installPhase = ''
    mkdir -p $out
    cp -r . $out
  '';
}

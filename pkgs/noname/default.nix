# https://nixos.org/manual/nixpkgs/stable/#javascript-pnpm
{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  nodejs_24,
  pnpm_10,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "noname";
  version = "v1.11.3";

  src = fetchFromGitHub {
    owner = "libnoname";
    repo = "noname";
    rev = finalAttrs.version;
    hash = "sha256-NXm9nFdTAvcKo9eiNDG1tgFwCfB7waFwEZebLv8ah3c=";
  };

  pnpmRoot = ".";

  nativeBuildInputs = [
    nodejs_24
    pnpm_10
    pnpmConfigHook
    makeWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmRoot
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-dqhESUT0LhWvLRdr/IAbQygyxMjDZyNJjh1VqAgtsE8=";
  };

  pnpmInstallFlags = [ "--frozen-lockfile" ];

  buildPhase = ''
    runHook preBuild

    cd ${finalAttrs.pnpmRoot}
    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/noname
    cp -r ./* $out/share/noname

    mkdir -p $out/bin

    makeWrapper ${nodejs_24}/bin/node $out/bin/noname-server \
            --add-flags "$out/share/noname/packages/fs/dist/entry.cjs" \
            --add-flags "--server" \
            --add-flags "--dirname=$out/share/noname/dist"

    runHook postInstall
  '';

  meta = with lib; {
    description = "noname (libnoname/noname) packaged from tag source;";
    homepage = "https://github.com/libnoname/noname";
    license = licenses.gpl3Only;
    platforms = platforms.linux ++ platforms.darwin;
  };
})

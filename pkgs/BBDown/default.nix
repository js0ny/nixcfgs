{
  stdenv,
  lib,
  unzip,
  autoPatchelfHook,
  zlib,
  icu,
  callPackage,
}:

let
  sources = callPackage ../../_sources/generated.nix { };

  archMap = {
    "x86_64-linux" = sources.bbdown-linux-x64;
    "aarch64-linux" = sources.bbdown-linux-arm64;
    "aarch64-darwin" = sources.bbdown-osx-arm64;
  };

  system = stdenv.hostPlatform.system;

  p = archMap.${system} or (throw "BBDown: Unsupported system ${system}");
in
stdenv.mkDerivation {
  pname = "BBDown";
  inherit (p) version src;

  nativeBuildInputs = [
    unzip
  ]
  ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [
    zlib
    icu
    stdenv.cc.cc.lib
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp BBDown $out/bin/
    chmod +x $out/bin/BBDown
  '';

  meta = with lib; {
    description = "Bilibili Downloader. 一个命令行式哔哩哔哩下载器.";
    homepage = "https://github.com/nilaoda/BBDown";
    license = licenses.mit;
    platforms = builtins.attrNames archMap;
  };
}

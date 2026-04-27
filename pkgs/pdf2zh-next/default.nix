{
  lib,
  pkgs,
  uv,
}:

pkgs.buildFHSEnv {
  name = "pdf2zh";

  targetPkgs =
    pkgs: with pkgs; [
      uv
      fontconfig
      freetype
      glib
      libGL
      libxkbcommon
      libx11
      libxext
      libxrender
      libxcb
      zlib
    ];

  runScript = pkgs.writeShellScript "pdf2zh-wrapper" ''
    exec ${lib.getExe uv} tool run --python 3.12 --from pdf2zh-next pdf2zh "$@"
  '';

  meta = {
    description = "PDF Translator based on BabelDOC";
    homepage = "https://github.com/PDFMathTranslate-next/PDFMathTranslate-next";
    mainProgram = "pdf2zh";
    platforms = lib.platforms.all;
  };
}

{
  lib,
  writeShellApplication,
  uv,
}:

writeShellApplication {
  name = "pdf2zh";

  runtimeInputs = [ uv ];

  text = ''
    exec ${lib.getExe uv} tool run --python 3.12 --from pdf2zh-next pdf2zh "$@"
  '';

  meta = {
    description = "PDF Translator based on BabelDOC";
    homepage = "https://github.com/PDFMathTranslate-next/PDFMathTranslate-next";
    mainProgram = "pdf2zh";
    platforms = lib.platforms.all;
  };
}

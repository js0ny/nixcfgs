{ pkgs, lib, ... }:
let
  # Pandoc delegates syntax highlighting to Typst, which only knows a handful of
  # languages, so code blocks are styled by codly instead. The wrapped Typst
  # carries the packages in TYPST_PACKAGE_CACHE_PATH, i.e. it resolves them
  # offline. Keep plain `typst` on PATH for interactive use.
  typstWithCodly = pkgs.typst.withPackages (ps: [
    ps.codly
    ps.codly-languages
  ]);

  # https://github.com/Dherse/codly#configuration
  codlyHeader = pkgs.writeText "pandoc-codly.typ" /* typst */ ''
    #show raw: set text(font: "Maple Mono NF")

    #import "@preview/codly:${pkgs.typstPackages.codly.version}": *
    #import "@preview/codly-languages:${pkgs.typstPackages.codly-languages.version}": *
    #show: codly-init.with()
    #codly(languages: codly-languages)
  '';

  md2pdf = pkgs.writeShellScriptBin "md2pdf" /* bash */ ''
    ${lib.getExe pkgs.pandoc} "$1" -o "''${2:-''${1:r}.pdf}" --defaults pdf
  '';
in
{
  xdg.dataFile = {
    "pandoc/defaults/pdf.yaml".text = /* yaml */ ''
      pdf-engine: ${lib.getExe typstWithCodly}
      include-in-header:
        - ${codlyHeader}

      variables:
        mainfont:
          - Libertinus Serif
    '';
    "kio/servicemenus/md2pdf.desktop" = {
      text = /* desktop */ ''
        [Desktop Entry]
        Type=Service
        ServiceTypes=KonqPopupMenu/Plugin
        MimeType=text/markdown
        Actions=md2pdf
        X-KDE-ServiceTypes=KonqPopupMenu/Plugin
        TryExec=${lib.getExe pkgs.pandoc}

        [Desktop Action md2pdf]
        Name=Convert Markdown to PDF
        Icon=scans2pdf
        Exec=${lib.getExe pkgs.pandoc} "%f" -o "%f.pdf" --defaults pdf
        Name[zh_CN]=将 Markdown 转换为 PDF
      '';
      executable = true;
    };
  };
  home.packages = with pkgs; [
    pandoc
    md2pdf
    typst
  ];
}

{ pkgs, ... }:
let
  md2pdf = pkgs.writeShellScriptBin "md2pdf" /* bash */ ''
    pandoc "$1" -o "''${2:-''${1:r}.pdf}" --defaults pdf
  '';
in
{
  xdg.dataFile."pandoc/defaults/pdf.yaml".text = /* yaml */ ''
    pdf-engine: typst

    variables:
      mainfont:
        - Libertinus Serif
      codefont: Maple Mono NF CN
  '';
  home.packages = with pkgs; [
    pandoc
    md2pdf
    typst
  ];
}

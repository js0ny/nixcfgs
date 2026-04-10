{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = [ pkgs.uv ];
  home.activation.uvInstallPdf2Zh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.local/bin"
    if [ ! -f $HOME/.local/bin/pdf2zh ]; then
      uv tool install pdf2zh-next
    fi
  '';
}

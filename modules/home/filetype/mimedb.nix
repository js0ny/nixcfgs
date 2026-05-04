{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  xdg.dataFile."mime/packages" = {
    source = ./mimepkgs;
    recursive = true;
  };
  xdg.mime.enable = true;

  home.activation.updateMimeDatabase = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${lib.getExe pkgs.shared-mime-info} "${config.xdg.dataHome}/mime"
  '';
}

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

  home.activation.updateMimeDatabase = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.shared-mime-info}/bin/update-mime-database "${config.xdg.dataHome}/mime"
  '';
}

{
  pkgs,
  lib,
  ...
}:
let
  magicDir = ./magic;

  customMagicCompiled = pkgs.runCommand "custom.magic.mgc" { } ''
    cat ${magicDir}/*.magic > custom.magic

    ${pkgs.file}/bin/file -C -m custom.magic

    mv custom.magic.mgc $out
  '';
in
lib.mkIf pkgs.stdenv.isLinux {
  home.sessionSearchVariables = {
    MAGIC = [
      "${customMagicCompiled}"
      "/run/current-system/sw/share/misc/magic"
    ];
  };
}

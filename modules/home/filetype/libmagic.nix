{
  pkgs,
  lib,
  ...
}: let
  magicDir = ./magic;

  # 在构建阶段：合并所有 .magic 文件并编译
  customMagicCompiled = pkgs.runCommand "custom.magic.mgc" {} ''
    cat ${magicDir}/*.magic > custom.magic

    ${pkgs.file}/bin/file -C -m custom.magic

    mv custom.magic.mgc $out
  '';
in
  lib.mkIf pkgs.stdenv.isLinux {
    home.sessionVariables = {
      # 链式注入：优先读取我们编译好的合并库，然后 fallback 到系统默认库
      MAGIC = "${customMagicCompiled}:/run/current-system/sw/share/misc/magic";
    };
  }

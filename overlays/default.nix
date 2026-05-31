final: prev:
let
  inherit (prev) lib;

  # 1. 扫描当前目录
  files = builtins.readDir ./.;

  # 2. 过滤出所有的 .nix 文件 (排除 default.nix)
  overlayFiles = lib.filterAttrs (
    name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) files;

  # 3. 动态导入所有 overlay 函数
  overlays = lib.mapAttrsToList (name: _: import (./. + "/${name}")) overlayFiles;
in
# 4. 将所有散落的 overlay 安全地揉合成一个超级 overlay
lib.composeManyExtensions overlays final prev

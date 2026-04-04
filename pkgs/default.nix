{
  pkgs,
  lib,
  ...
}: let
  # 递归扫描目录并调用 callPackage
  # 如果目录下有 default.nix，则视其为一个包
  # 如果目录下没有 default.nix，则继续递归，形成命名空间
  scanPackages = path: let
    content = builtins.readDir path;
  in
    lib.mapAttrs (
      name: type: let
        subdir = path + "/${name}";
      in
        if type == "directory"
        then
          if builtins.pathExists (subdir + "/default.nix")
          then
            # 发现具体的包定义，执行实例化
            pkgs.callPackage subdir {}
          else
            # 这是一个分类目录，继续往下钻，形成嵌套 AttrSet
            scanPackages subdir
        else
          # 忽略非目录文件（比如这个 default.nix 自身）
          null
    )
    content;

  # 运行扫描并清理无效的 null 值
  rawPackages = scanPackages ./.;
in
  # 递归过滤掉因扫描产生的 null（即目录里的普通文件）
  lib.filterAttrsRecursive (n: v: v != null && n != "default.nix") rawPackages

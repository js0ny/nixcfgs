{ lib, ... }:
rec {
  scanPaths =
    path:
    map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );
  scanDefaultsRec =
    path:
    let
      dirs = map (f: path + "/${f}") (
        builtins.attrNames (
          lib.attrsets.filterAttrs (_path: _type: _type == "directory") (builtins.readDir path)
        )
      );
    in
    lib.lists.concatMap (
      dir:
      (lib.lists.optionals (builtins.pathExists (dir + "/default.nix")) [ (dir + "/default.nix") ])
      ++ (scanDefaultsRec dir)
    ) dirs;
  toHanScript =
    lang:
    if lib.hasPrefix "zh-" lang then
      builtins.replaceStrings [ "CN" "SG" "HK" "TW" ] [ "Hans" "Hans" "Hant" "Hant" ] lang
    else
      lang;
}

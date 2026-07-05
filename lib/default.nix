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

  scanPathsRec =
    path:
    let
      entries = builtins.readDir path;
      pick = lib.attrsets.filterAttrs (
        _name: type:
        (type == "directory")
        || (type == "regular" && lib.strings.hasSuffix ".nix" _name && _name != "default.nix")
      ) entries;
      result = lib.attrsets.mapAttrsToList (
        name: type:
        if type == "directory" then scanPathsRec (path + "/${name}") else [ (path + "/${name}") ]
      ) pick;
    in
    lib.lists.concatLists result;
  toHanScript =
    lang:
    if lib.hasPrefix "zh-" lang then
      builtins.replaceStrings [ "CN" "SG" "HK" "TW" ] [ "Hans" "Hans" "Hant" "Hant" ] lang
    else
      lang;
}

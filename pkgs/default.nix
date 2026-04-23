{
  pkgs,
  lib,
  ...
}:
let
  scanPackages =
    path:
    let
      content = builtins.readDir path;
      dirs = lib.filterAttrs (name: type: type == "directory") content;
    in
    lib.mapAttrs (
      name: _:
      let
        subdir = path + "/${name}";
      in
      if builtins.pathExists (subdir + "/default.nix") then
        pkgs.callPackage subdir { }
      else
        scanPackages subdir
    ) dirs;

  localPkgs = scanPackages ./.;
in
localPkgs

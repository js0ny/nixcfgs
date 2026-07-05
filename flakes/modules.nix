{ lib, ... }:
let
  myLib = import ../lib { inherit lib; };
  modulesPath = ../modules;
  optionsPath = toString (modulesPath + "/options/");
in
{
  options.flake.darwinModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = { };
  };

  imports = lib.filter (path: !(lib.hasPrefix optionsPath (toString path))) (
    myLib.scanDefaultsRec modulesPath
  );
}

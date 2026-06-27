{ lib, ... }:
let
  myLib = import ../lib { inherit lib; };
in
{
  options.flake.darwinModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = { };
  };

  imports = myLib.scanDefaultsRec ../modules;
}

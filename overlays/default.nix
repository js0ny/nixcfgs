{ inputs }:

final: prev:
let
  inherit (prev) lib;

  files = builtins.readDir ./.;

  overlayFiles = lib.filterAttrs (
    name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) files;

  overlays = lib.mapAttrsToList (name: _: import (./. + "/${name}")) overlayFiles;
in
lib.composeManyExtensions overlays final prev
// {
  mv = inputs.multiverse.lib.mkMultiverse {
    system = final.stdenv.hostPlatform.system;
  };
}

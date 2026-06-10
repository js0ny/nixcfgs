{ inputs }:

final: prev:
let
  inherit (prev) lib;

  files = builtins.readDir ./.;

  overlayFiles = lib.filterAttrs (
    name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) files;

  overlays = lib.mapAttrsToList (
    name: _:
    let
      overlay = import (./. + "/${name}");
    in
    if
      builtins.elem name [
        "hermes-agent.nix"
      ]
    then
      overlay { inherit inputs; }
    else
      overlay
  ) overlayFiles;
in
lib.composeManyExtensions overlays final prev

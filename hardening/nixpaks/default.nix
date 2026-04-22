{
  pkgs,
  inputs,
  ...
}:
let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  callNixPak =
    path:
    pkgs.callPackage path {
      inherit mkNixPak;
    };
in
{
  nixpkgs.overlays = [
    (_: prev: {
      nixpaks = {
        discord = callNixPak ./discord.nix;
        qq = callNixPak ./qq.nix;
        termius = callNixPak ./termius.nix;
        zoom-us = callNixPak ./zoom-us.nix;
        spotify = callNixPak ./spotify.nix;
        ticktick = callNixPak ./ticktick.nix;
      };
    })
  ];
}

{ pkgs, lib, ... }:
{
  home.packages = lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
    # WiiU Emulator
    pkgs.cemu
  ];
  nixdots.darwin.homebrew.casks = [ "cemu" ];
}

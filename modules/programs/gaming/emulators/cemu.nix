{ pkgs, lib, ... }:
{
  home.packages =
    lib.optionals (pkgs.stdenv.hostPlatform.isLinux && pkgs.stdenv.hostPlatform.isx86_64)
      [
        # WiiU Emulator
        pkgs.cemu
      ];
  js0ny.homebrew.casks = [ "cemu" ];
}

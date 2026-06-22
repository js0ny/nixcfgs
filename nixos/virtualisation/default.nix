{ myLib, pkgs, ... }:
{
  imports = myLib.scanPaths ./.;
}

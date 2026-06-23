{ config, myLib, ... }:
{
  imports = myLib.scanPaths ./.;

}

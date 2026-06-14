{ myLib, ... }:
{
  imports = myLib.scanPaths ./.;
  hardware.enableRedistributableFirmware = true;
}

{ config, myLib, ... }:
{
  imports = myLib.scanPaths ./.;

  nixdots.persist.home = {
    directories = [
      ".ssh"
    ];
  };
}

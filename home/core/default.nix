{ config, myLib, ... }:
{
  imports = myLib.scanPaths ./.;
  home.username = config.nixdots.user.name;
  home.homeDirectory = config.nixdots.user.home;

  programs.home-manager.enable = true;

  nixdots.persist.home = {
    directories = [
      ".ssh"
    ];
  };
}

{ config, ... }:
{
  home.username = config.nixdots.user.name;
  home.homeDirectory = config.nixdots.user.home;

  programs.home-manager.enable = true;

  xdg.binHome = "${config.home.homeDirectory}/.local/bin";
  xdg.localBinInPath = true;

  nixdots.persist.home = {
    directories = [
      ".ssh"
    ];
  };
}

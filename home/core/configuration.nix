{ config, ... }: {
  home.username = config.nixdots.user.name;
  home.homeDirectory = config.nixdots.user.home;
  programs.home-manager.enable = true;
  home.sessionVariables = import ../../common/do-not-track-vars.nix;

  catppuccin = {
    enable = false;
    autoEnable = false;
    cache.enable = true;
  };
}

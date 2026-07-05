{ config, ... }: {
  home.username = config.nixdots.user.name;
  home.homeDirectory = config.nixdots.user.home;
  programs.home-manager.enable = true;

  catppuccin = {
    enable = false;
    autoEnable = false;
    cache.enable = true;
  };
}

{ config, ... }: {
  home.username = config.js0ny.user.name;
  home.homeDirectory = config.js0ny.user.home;
  programs.home-manager.enable = true;

  catppuccin = {
    enable = false;
    autoEnable = false;
    cache.enable = true;
  };
}

# https://github.com/different-name/steam-config-nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Steam Achievement Manager
    samira
    steamcmd # from overlays
    # Steam Adwaita Theme
    adwsteamgtk
    # All-in-one Steam and Proton Tools
    steamtinkerlaunch
  ];
  nixdots.persist.nosnap.home = {
    directories = [
      ".local/share/Steam"
      ".steam"
    ];
  };
  programs.steam.config = {
    enable = true;
    closeSteam = true;
  };
  # Lost & Found
  xdg.desktopEntries = {
    samira = {
      name = "Samira";
      icon = "samira";
      comment = "Steam achievement manager for Linux";
      exec = "samira";
      terminal = false;
      categories = [
        "Game"
      ];
      settings = {
        StartupWMClass = "samira";
      };
    };
  };
}

{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ../../programs/dolphin
    ./kwin.nix
    ./keymaps.nix
    ./calendar.nix
    ./panels.nix
    ./input.nix
    ./plasmarc.nix
    ./powerdevil.nix
    ../../../modules/home/plasma
  ];
  home.packages = with pkgs; [
    # kdePackages.yakuake
    plasmusic-toolbar
    kdePackages.krohnkite
    plasma-plugin-blurredwallpaper
  ];
  programs.plasma = {
    enable = true;
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    krunner = {
      position = "center";
    };
    desktop = {
      mouseActions = {
        middleClick = "paste";
        rightClick = "contextMenu";
      };
    };
    workspace = {
      splashScreen.theme = "org.kde.breeze.desktop";
      wallpaperCustomPlugin = {
        plugin = "a2n.blur";
      };
    };

  };
  nixdots.persist.home = {
    directories = [
      ".config/kdedefaults"
    ];
  };
}

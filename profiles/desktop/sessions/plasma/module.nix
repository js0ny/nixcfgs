{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    # keep-sorted start
    ./calendar.nix
    ./input.nix
    ./kderc.nix
    ./keymaps.nix
    ./kwin.nix
    ./panels.nix
    ./plasmarc.nix
    ./powerdevil.nix
    ./style.nix
    # keep-sorted end
  ];
  home.packages = with pkgs; [
    # kdePackages.yakuake
    plasmusic-toolbar
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

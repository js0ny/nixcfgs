{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    # keep-sorted start
    ../../linux/desktop/plasma
    ../../programs/dolphin
    ./calendar.nix
    ./input.nix
    ./keymaps.nix
    ./kwin.nix
    ./panels.nix
    ./plasmarc.nix
    ./powerdevil.nix
    # keep-sorted end
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

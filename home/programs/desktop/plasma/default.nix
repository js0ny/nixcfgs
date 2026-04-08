{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../../gwenview.nix
    ../../dolphin
    ./kwin.nix
    ./keymaps.nix
    ./calendar.nix
    ./panels.nix
    ./input.nix
  ];
  home.packages = with pkgs; [
    # kdePackages.yakuake
    krunner-vscodeprojects
    plasmusic-toolbar
    plasma-plugin-blurredwallpaper
    kdePackages.krohnkite
  ];
  programs.plasma = {
    enable = true;
    # Apply the icon fix rules
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    fonts = {
      fixedWidth.family = "${config.stylix.fonts.monospace.name}";
      fixedWidth.pointSize = 10;
      general.family = "${config.stylix.fonts.sansSerif.name}";
      general.pointSize = 10;
    };
    krunner = {
      position = "center";
    };
  };
  programs.okular = {
    enable = true;
    accessibility.changeColors.mode = "InvertLightness";
    general.mouseMode = "TextSelect";
  };
  programs.kate.enable = false;
  programs.kate.editor = {
    font = {
      family = "${config.stylix.fonts.monospace.name}";
      pointSize = 10;
    };
    inputMode = "vi";
  };
  nixdots.persist.home = {
    directories = [
      ".config/kdedefaults"
    ];
    files = [
      ".config/kdeglobals"
      ".config/ktimezonedrc"
      ".config/kcminputrc"
      ".config/kglobalshortcutsrc"
      ".config/plasma-org.kde.plasma.desktop-appletsrc"
    ];
  };
  xdg.configFile."plasma-localerc" = {
    text = lib.generators.toINI {} {
      Formats.LANG = "en_GB.UTF-8";
    };
    force = true;
  };
}

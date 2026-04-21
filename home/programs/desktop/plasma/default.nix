{
  pkgs,
  config,
  lib,
  ...
}:
{
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
    workspace = {
      splashScreen.theme = "org.kde.breeze.desktop";
      iconTheme = "Papirus-Dark";
    };
    configFile = {
      kdeglobals = {
        General = {
          TerminalApplication = lib.getExe config.nixdots.apps.terminal.package;
          TerminalService = config.nixdots.apps.terminal.desktop;
        };
      };
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
      ".config/ktimezonedrc"
      ".config/kcminputrc"
    ];
  };
  xdg.configFile."plasma-localerc" = {
    text = lib.generators.toINI { } {
      Formats.LANG = "en_GB.UTF-8";
    };
    force = true;
  };
}

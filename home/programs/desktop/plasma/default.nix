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
  ];
  home.packages = with pkgs; [
    # kdePackages.yakuake
    krunner-vscodeprojects
    jetbrains-runner
    plasmusic-toolbar
    kdePackages.wallpaper-engine-plugin
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
    # workspace = {
    #   iconTheme = "${config.nixdots.desktop.style.iconTheme.dark}";
    #   colorScheme = "BreezeDark";
    # };
    kwin = {
      virtualDesktops.number = 9;
      titlebarButtons = {
        left = [
          "more-window-actions"
          "on-all-desktops"
          "keep-above-windows"
        ];
      };
    };
    shortcuts = {
    };
    input.touchpads = [
      {
        disableWhileTyping = true;
        enable = true;
        leftHanded = true;
        middleButtonEmulation = true;
        name = "ASUP1208:00 093A:3011 Touchpad";
        productId = "3011";
        vendorId = "093A";
        naturalScroll = true;
        pointerSpeed = 0;
        tapToClick = true;
        accelerationProfile = "none";
        scrollSpeed = 0.15;
      }
    ];

    panels = [
      # Windows-like panel at the bottom
      {
        location = "bottom";
        widgets = [
          # "org.kde.plasma.kickoff"
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "distributor-logo-nixos";
                alphaSort = true;
              };
            };
          }
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General = {
                launchers = [
                  # "applications:org.kde.dolphin.desktop"
                  "applications:firefox.desktop"
                  "applications:kitty.desktop"
                ];
              };
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          {
            name = "org.kde.plasma.digitalclock";
            config = {
              Appearance = {
                dateFormat = "isoDate";
                enabledCalendarPlugins = "alternatecalendar,holidaysevents";
                firstDayOfWeek = 1;
                selectedTimeZones = "Local,Asia/Shanghai,Europe/London";
                showSeconds = "Always";
                showWeekNumbers = true;
                use24hFormat = 2;
                dateDisplayFormat = "BelowTime";
              };
            };
          }
          "org.kde.plasma.showdesktop"
        ];
      }
      # Global menu at the top
      {
        location = "top";
        height = 20;
        widgets = [
          "org.kde.plasma.pager"
          "org.kde.plasma.windowlist"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemmonitor.memory"
        ];
        opacity = "translucent";
        hiding = "none";
      }
    ];
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
}

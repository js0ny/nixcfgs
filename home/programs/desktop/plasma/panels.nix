{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    plasmusic-toolbar
  ];
  programs.plasma = {
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
                  # "applications:kitty.desktop"
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
                # selectedTimeZones = "Local,Etc/UTC,Asia/Shanghai,Europe/London";
                selectedTimeZones = "Local,${lib.concatStringsSep "," config.nixdots.core.timezones}";
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
          "org.kde.plasma.panelspacer"
          "plasmusic-toolbar"
          "org.kde.plasma.systemmonitor.memory"
          "org.kde.plasma.systemmonitor.cpucore"
        ];
        opacity = "translucent";
        hiding = "none";
      }
    ];
  };
}

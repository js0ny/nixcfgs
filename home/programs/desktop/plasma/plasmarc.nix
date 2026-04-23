{ lib, config, ... }:
let
  toINI = lib.generators.toINI;
in
{
  xdg.configFile = {
    "plasma-localerc".text = toINI { } {
      Formats.LANG = "en_GB.UTF-8";
    };
    "ktimezonedrc".text = toINI { } {
      TimeZones = {
        LocalZone = builtins.head config.nixdots.core.timezones;
        ZoneinfoDir = "/etc/zoneinfo";
        Zonetab = "/etc/zoneinfo/zone.tab";
      };
    };
  };
}

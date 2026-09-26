{ lib, config, ... }:
let
  toINI = lib.generators.toINI;
  locales = config.js0ny.host.locales;
in
{
  xdg.configFile = {
    "plasma-localerc".text = toINI { } {
      Formats.LANG = locales.default;
    };
    "ktimezonedrc".text = toINI { } {
      TimeZones = {
        LocalZone = builtins.head config.js0ny.host.timezones;
        ZoneinfoDir = "/etc/zoneinfo";
        Zonetab = "/etc/zoneinfo/zone.tab";
      };
    };
  };
}

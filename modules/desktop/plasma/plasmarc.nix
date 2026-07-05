{ lib, config, ... }:
let
  toINI = lib.generators.toINI;
  locales = config.nixdots.core.locales;
in
{
  xdg.configFile = {
    "plasma-localerc".text = toINI { } {
      Formats.LANG = locales.default;
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

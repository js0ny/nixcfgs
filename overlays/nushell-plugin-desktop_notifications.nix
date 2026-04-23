final: prev:
let
  lib = prev.lib;
in
{
  nushellPlugins.desktop_notifications = {
    final.meta.platforms = with lib.platforms; linux + darwin;
  };
}

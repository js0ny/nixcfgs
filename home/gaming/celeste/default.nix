{ lib, config, ... }:
let
  dots = config.nixdots.core.dots;
  user = config.nixdots.user.name;
in
{
  programs.celeste = {
    enable = true;
    withSteam = true;
    withOlympus = true;
    settingsFile = "${dots}/users/${user}/programs/gaming/celeste/settings.celeste";
  };
}

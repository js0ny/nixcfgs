{
  pkgs,
  lib,
  config,
  ...
}:
let
  dots = config.nixdots.core.dots;
  user = config.js0ny.user.name;
in
{
  home.packages = with pkgs; [ (olympus.override { celesteWrapper = "steam-run"; }) ];
  home.file.".local/share/Celeste/Backups/settings.celeste".source =
    config.lib.file.mkOutOfStoreSymlink "${dots}/users/${user}/programs/gaming/celeste/settings.celeste";

  nixdots.persist.home = {
    directories = [
      ".local/share/Celeste"
      ".config/Olympus"
    ];
  };
}

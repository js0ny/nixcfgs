{
  pkgs,
  lib,
  config,
  ...
}:
let
  dots = config.js0ny.host.flakeDir;
  user = config.js0ny.user.name;
in
{
  home.packages = with pkgs; [ (olympus.override { celesteWrapper = "steam-run"; }) ];
  home.file.".local/share/Celeste/Backups/settings.celeste".source =
    config.lib.file.mkOutOfStoreSymlink "${dots}/users/${user}/programs/gaming/celeste/settings.celeste";

  js0ny.persist.stores.state.directories = [
    ".local/share/Celeste"
    ".config/Olympus"
  ];
}

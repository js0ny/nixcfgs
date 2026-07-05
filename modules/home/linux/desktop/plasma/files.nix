{ config, lib, ... }:
{
  programs.plasma.configFile = {
    baloofilerc = {
      General = {
        dbVersion = 2;
        "exclude folders" = "$HOME/";
        folders = lib.concatStringsSep "," (
          lib.mapAttrsToList (name: _: "$HOME/${name}") (
            lib.filterAttrs (_: dir: dir.enable && dir.pin) config.home.directories
          )
        );
        "only basic indexing" = false;
      };
    };
  };
}

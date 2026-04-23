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
        # [
        #   "$HOME/Academia/,$HOME/Atelier/,$HOME/Obsidian/"
        # ];
        "only basic indexing" = false;
      };
    };
    kiorc = {
      Confirmations = {
        ConfirmDelete = true;
        ConfirmEmptyTrash = true;
        ConfirmTrash = false;
      };
      "Executable scripts".behaviourOnLaunch = "alwaysAsk";
    };
  };
}

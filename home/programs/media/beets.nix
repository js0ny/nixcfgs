{ lib, config, ... }:
let
  dataDir = config.xdg.dataHome;
  library =
    if config.nixdots.persist.enable then
      "${config.nixdots.persist.path}${dataDir}/beets/library.db"
    else
      "${dataDir}/beets/library.db";
in
{
  programs.beets = {
    enable = true;
    settings = {
      library = lib.mkDefault library;
      directory = lib.mkDefault config.xdg.userDirs.music;
      plugins = builtins.concatStringsSep " " [
        "musicbrainz"
        "rewrite"
        "fish"
        "zero"
        "fetchart"
      ];
      rewrite =
        let
          artistMap = from: to: {
            name = "artist ${from}";
            value = to;
          };
        in
        builtins.listToAttrs [
          (artistMap "Пётр Ильич Чайковский" "Pyotr Ilyich Tchaikovsky")
          (artistMap "Johann Strauss (Sohn)" "Johann Strauss II")
        ];
      zero = {
        fields = "comments";
        comments = [
          "ripped by"
          "EAC"
          "LAME"
          "from.+collection"
          "[Dd]ownloaded from"
        ];
        update_database = true;
      };
      fetchart = {
        cover_names = "cover front albumart folder";
      };
    };
  };
}

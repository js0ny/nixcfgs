{ config, ... }:
let
  dataDir = config.xdg.dataHome;
in
{
  programs.beets = {
    enable = true;
    settings = {
      library = "${dataDir}/beets/library.db";
      directory = config.xdg.userDirs.music;
      plugins = "musicbrainz rewrite fish zero fetchart";
      rewrite =
        let
          artistMap = from: to: {
            key = "artist ${from}";
            vaule = to;
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

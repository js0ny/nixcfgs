{
  flake.homeModules.beets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      dataDir = config.xdg.dataHome;
      library =
        if config.js0ny.persist.enable then
          "${config.js0ny.persist.stores.state.persistentStoragePath}${dataDir}/beets/library.db"
        else
          "${dataDir}/beets/library.db";

      riffInfoSync = pkgs.stdenv.mkDerivation {
        pname = "riff-info-sync";
        version = "0.3.0";

        src = ./.;

        nativeBuildInputs = [ pkgs.pkg-config ];

        buildInputs = [
          pkgs.cli11
          pkgs.taglib
          # taglib.pc hardcodes `-lz` without propagating zlib
          pkgs.zlib
        ];

        dontConfigure = true;

        buildPhase = ''
          runHook preBuild
          $CXX -std=c++20 -O2 -Wall -Wextra riff-info-sync.cxx \
            $(${lib.getExe pkgs.pkg-config} --cflags --libs taglib) -o riff-info-sync
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          install -Dm755 riff-info-sync $out/bin/riff-info-sync
          runHook postInstall
        '';

        meta.mainProgram = "riff-info-sync";
      };
    in
    {
      home.packages = [ riffInfoSync ];

      programs.beets = {
        enable = true;
        settings = {
          library = lib.mkDefault library;
          # Beets will not expand `$HOME`
          directory = lib.mkDefault "${config.home.homeDirectory}/Music";
          plugins = builtins.concatStringsSep " " [
            "musicbrainz"
            "rewrite"
            "fish"
            "zero"
            "fetchart"
            "thumbnails"
            "hook"
          ];
          # https://beets.readthedocs.io/en/stable/plugins/hook.html
          hook.hooks = [
            {
              event = "after_write";
              command = ''${lib.getExe riffInfoSync} --quiet -- "{path}"'';
            }
          ];
          rewrite =
            let
              artistMap = from: to: {
                name = "^artist ${from}$";
                value = to;
              };
            in
            builtins.listToAttrs [
              (artistMap "Пётр Ильич Чайковский" "Pyotr Ilyich Tchaikovsky")
              (artistMap "Johann Strauss \\(Sohn\\)" "Johann Strauss II")
            ];
          zero = {
            fields = "comments";
            comments = [
              "ripped by"
              "EAC"
              "LAME"
              "from.+collection"
              "[Dd]ownloaded from"
              "自抓"
              "自购"
              "原贴"
            ];
            update_database = true;
          };
          fetchart = {
            cover_names = "cover front albumart folder";
          };
          thumbnails = {
            auto = "yes";
            dolphin = "yes";
          };
        };
      };
    };
}

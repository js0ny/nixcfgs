{ pkgs, ... }: {
  programs.yazi = {
    plugins = {
      git = pkgs.yaziPlugins.git;
      starship = pkgs.yaziPlugins.starship;
      ouch = pkgs.yaziPlugins.ouch;
      bookmarks = pkgs.yaziPlugins.bookmarks;
      clipboard = pkgs.yaziPlugins.clipboard;
      dump-tabs = pkgs.js0ny.yaziPlugins.dump-tabs;
      piper = pkgs.yaziPlugins.piper;
      chmod = pkgs.yaziPlugins.chmod;
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
      ];
    };
    settings = {
      plugin.prepend_fetchers = [
        {
          group = "git";
          url = "*";
          run = "git";
        }
        {
          group = "git";
          url = "*/";
          run = "git";
        }
      ];
      plugin.prepend_previewers = [
        {
          mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
          run = "ouch --show-file-icons";
        }
      ];
    };
  };
}

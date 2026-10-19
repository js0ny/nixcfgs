{ pkgs, ... }: {
  programs.yazi = {
    plugins = {
      inherit (pkgs.yaziPlugins)
        # keep-sorted start
        bookmarks
        chmod
        clipboard
        git
        piper
        starship
        # keep-sorted end
        ;
      inherit (pkgs.js0ny.yaziPlugins) dump-tabs;
      confirm-quit = ./plugins/confirm-quit.yazi;
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "q";
          run = "plugin confirm-quit";
          desc = "Quit with confirmation if multiple tabs are open";
        }
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
    };
  };
}

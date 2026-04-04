{
  pkgs,
  config,
  ...
}: let
  dots = config.nixdots.core.dots;
in {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    shellWrapperName = "y";
    plugins = {
      git = pkgs.yaziPlugins.git;
      starship = pkgs.yaziPlugins.starship;
      smart-paste = pkgs.yaziPlugins.smart-paste;
      mediainfo = pkgs.yaziPlugins.mediainfo;
      ouch = pkgs.yaziPlugins.ouch;
      bookmarks = pkgs.yaziPlugins.bookmarks;
    };
    settings = {
      preview.wrap = "yes";
      mgr = {
        show_hidden = true;
        linemode = "size_and_mtime";
      };
      plugin = {
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
        prepend_preloaders = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }

          # Adobe Illustrator & Postscript
          {
            mime = "application/postscript";
            run = "mediainfo";
          }
          {
            mime = "application/illustrator";
            run = "mediainfo";
          }
          {
            mime = "application/dvb.ait";
            run = "mediainfo";
          }
          {
            mime = "application/vnd.adobe.illustrator";
            run = "mediainfo";
          }
          {
            mime = "image/x-eps";
            run = "mediainfo";
          }
          {
            mime = "application/eps";
            run = "mediainfo";
          }

          # Extension fallback for AI files
          {
            url = "*.{ai,eps,ait}";
            run = "mediainfo";
          }

          # Specific flags
          {
            mime = "{image}/*";
            run = "mediainfo --no-metadata";
          }
          {
            mime = "{video}/*";
            run = "mediainfo --no-preview";
          }
        ];
        prepend_previewers = [
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch --show-file-icons";
          }
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }

          # Adobe Illustrator & Postscript
          {
            mime = "application/postscript";
            run = "mediainfo";
          }
          {
            mime = "application/illustrator";
            run = "mediainfo";
          }
          {
            mime = "application/dvb.ait";
            run = "mediainfo";
          }
          {
            mime = "application/vnd.adobe.illustrator";
            run = "mediainfo";
          }
          {
            mime = "image/x-eps";
            run = "mediainfo";
          }
          {
            mime = "application/eps";
            run = "mediainfo";
          }

          # Extension fallback for AI files
          {
            url = "*.{ai,eps,ait}";
            run = "mediainfo";
          }

          # Specific flags
          # {
          #   mime = "{image}/*";
          #   run = "mediainfo --no-metadata";
          # }
          {
            mime = "{video}/*";
            run = "mediainfo --no-preview";
          }
        ];
      };
      opener = {
        extract = [
          {
            run = ''ouch d -y %*'';
            desc = "Extract here with ouch";
            for = "windows";
          }
          {
            run = ''ouch d -y "$@"'';
            desc = "Extract here with ouch";
            for = "unix";
          }
        ];
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "K";
          run = "seek -5";
          desc = "Seek up 5 units in the preview";
        }
        {
          on = "J";
          run = "seek 5";
          desc = "Seek down 5 units in the preview";
        }
        # Find
        {
          on = ["g" "p"];
          run = "cd ~/Pictures";
          desc = "Go ~/Pictures/";
        }
        {
          on = ["g" "c"];
          run = "cd ${dots}";
          desc = "Go dotfiles";
        }
        {
          on = ["g" "/"];
          for = "unix";
          run = "cd /";
          desc = "Go to root";
        }
        {
          on = ["g" "/"];
          for = "windows";
          run = "cd C:";
          desc = "Go to root";
        }
        {
          on = "!";
          for = "unix";
          run = ''shell "$SHELL" --block'';
          desc = "Open $SHELL here";
        }
        {
          on = "!";
          for = "windows";
          run = ''shell "$SHELL" --block'';
          desc = "Open $SHELL here";
        }
        {
          on = ["C"];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
        {
          on = ["m"];
          run = "plugin bookmarks save";
          desc = "Save current position as a bookmark";
        }
        {
          on = ["'"];
          run = "plugin bookmarks jump";
          desc = "Jump to a bookmark";
        }
        {
          on = ["b" "d"];
          run = "plugin bookmarks delete";
          desc = "Delete a bookmark";
        }
        {
          on = ["b" "D"];
          run = "plugin bookmarks delete_all";
          desc = "Delete all bookmarks";
        }
        {
          on = "p";
          run = "plugin smart-paste";
          desc = "Paste into the hovered directory or CWD";
        }
        {
          on = "A";
          run = "create --dir";
          desc = "Create directory";
        }
        {
          on = "<C-n>";
          run = "shell -- ripdrag %s -x 2>/dev/null &";
        }
      ];
    };
    initLua = builtins.readFile ./init.lua;
  };
  home.packages = with pkgs; [
    (ouch.override {enableUnfree = true;})
  ];
  nixdots.persist.home = {
    files = [
      # Persist bookmarks
      ".local/state/yazi/.dds"
    ];
  };
}

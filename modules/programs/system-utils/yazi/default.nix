{
  flake.nixosModules.yazi = _: {
    programs.yazi = {
      enable = true;
    };
  };
  flake.homeModules.yazi =
    {
      pkgs,
      config,
      ...
    }:
    let
      dots = config.nixdots.core.dots;
      xdgDirs = config.xdg.userDirs;
    in
    {
      imports = [
        ./mediainfo.nix
        ./piper.nix
      ];
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
          clipboard = pkgs.yaziPlugins.clipboard;
          dump-tabs = pkgs.js0ny.yaziPlugins.dump-tabs;
          piper = pkgs.yaziPlugins.piper;
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
            prepend_previewers = [
              {
                mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
                run = "ouch --show-file-icons";
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
              on = [
                "g"
                "p"
              ];
              run = "cd ${xdgDirs.pictures}";
              desc = "Goto Pictures/";
            }
            {
              on = [
                "g"
                "D"
              ];
              run = "cd ${xdgDirs.documents}";
              desc = "Goto Documents/";
            }
            {
              on = [
                "g"
                "-" # mimic cd -
              ];
              run = "back";
              desc = "Go to previous directory";
            }
            {
              on = [
                "g"
                "c"
              ];
              run = "cd ${dots}";
              desc = "Go dotfiles";
            }
            {
              on = [
                "g"
                "/"
              ];
              for = "unix";
              run = "cd /";
              desc = "Go to root";
            }
            {
              on = [
                "g"
                "/"
              ];
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
              on = [ "C" ];
              run = "plugin ouch";
              desc = "Compress with ouch";
            }
            {
              on = [ "m" ];
              run = "plugin bookmarks save";
              desc = "Save current position as a bookmark";
            }
            {
              on = [ "'" ];
              run = "plugin bookmarks jump";
              desc = "Jump to a bookmark";
            }
            {
              on = [
                "b"
                "d"
              ];
              run = "plugin bookmarks delete";
              desc = "Delete a bookmark";
            }
            {
              on = [
                "b"
                "D"
              ];
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
            {
              on = "<C-x>";
              run = [
                "yank"
                "plugin clipboard -- --action=copy"
              ];
              desc = "Copy file to clipboard";
              for = "linux";
            }
            {
              on = "<C-v>";
              run = [ "plugin clipboard -- --action=paste" ];
              desc = "Copy file to clipboard";
              for = "linux";
            }
            {
              on = [
                "t"
                "q"
              ];
              run = "tab_close";
              desc = "Close current tab";
            }
            {
              on = "<C-s>";
              run = "plugin dump-tabs -- --format=cmd";
              desc = "Dump tabs as yazi command";
            }
          ];
        };

        initLua = builtins.readFile ./init.lua;
      };
      home.packages = with pkgs; [
        (ouch.override { enableUnfree = true; })
      ];

      nixdots.persist.nosnap.home.files = [
        # Persist bookmarks
        ".local/state/yazi/.dds"
      ];

    };
  flake.nixosModules.core = { inputs, ... }: {
    imports = [ inputs.self.nixosModules.yazi ];
  };
  flake.homeModules.core = { inputs, ... }: {
    imports = [ inputs.self.homeModules.yazi ];
  };
}

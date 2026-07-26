{ config, ... }:
let
  dots = config.nixdots.core.dots;
  xdgDirs = config.xdg.userDirs;
in
{
  # https://yazi-rs.github.io/docs/configuration/keymap
  # Default: https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/keymap-default.toml
  programs.yazi.keymap = {
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
        run = ''shell "export IN_YAZI=1 && $SHELL" --block'';
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
      {
        on = "<S-Delete>";
        desc = "Delete selected files";
        run = "remove";
      }
      {
        on = "<Delete>";
        desc = "Delete selected files permanently";
        run = "remove --permanently";
      }
    ];
    input.prepend_keymap = [
      {
        on = "<C-Backspace>"; # C-w
        run = "kill backward";
        desc = "Kill backwards to the start of the current word";
      }
      {
        on = "<C-Delete>"; # A-d
        run = "kill backward";
        desc = "Kill backwards to the start of the current word";
      }
      {
        on = "<A-Backspace>"; # C-u
        run = "kill bol";
        desc = "Kill backwards to the start of the current word";
      }
      {
        on = "<A-Delete>"; # C-k
        run = "kill eol";
        desc = "Kill backwards to the start of the current word";
      }
    ];
  };
}

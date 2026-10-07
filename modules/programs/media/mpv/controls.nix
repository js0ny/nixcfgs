{ lib, ... }:
let
  # Update playback and briefly reveal the corresponding uosc indicator.
  # Seek values are seconds; volume values are percentage points; speed values are multiplier deltas.
  seek = val: "seek ${val}; script-binding uosc/flash-timeline";
  volume = val: "no-osd add volume ${val}; script-binding uosc/flash-volume";
  speed = val: "no-osd add speed ${val}; script-binding uosc/flash-speed";
  # uosc navigates the playlist, or neighbouring files when there is no playlist.
  next = "script-binding uosc/next; script-message-to uosc flash-elements top_bar,timeline";
  prev = "script-binding uosc/prev; script-message-to uosc flash-elements top_bar,timeline";

  # This replaces uosc's default menu; list order determines the displayed menu order.
  # Menu shortcuts live alongside their actions so uosc can display their hints.
  entries = [
    {
      key = "P";
      command = "script-binding uosc/items";
      menu = "Files > Playlist / Files";
    }
    {
      command = "script-binding uosc/open-file";
      menu = "Files > Open file";
    }
    {
      command = "script-binding uosc/paste-to-open";
      menu = "Files > Open clipboard path or URL";
    }
    {
      command = "script-binding uosc/show-in-directory";
      menu = "Files > Show in file manager";
    }
    {
      command = "script-binding memo/memo-history";
      menu = "History";
    }
    {
      command = "script-binding memo/memo-history";
      menu = "Files > Recent file";
    }

    {
      command = "script-binding uosc/subtitles";
      menu = "Subtitles > Select track";
    }
    {
      command = "script-binding uosc/load-subtitles";
      menu = "Subtitles > Load external subtitles";
    }
    {
      command = "cycle sub-visibility";
      menu = "Subtitles > Toggle visibility";
    }

    {
      command = "script-binding uosc/audio";
      menu = "Audio > Select track";
    }
    {
      command = "script-binding uosc/audio-device";
      menu = "Audio > Output device";
    }
    {
      command = "cycle mute";
      menu = "Audio > Toggle mute";
    }

    {
      command = "script-binding uosc/video";
      menu = "Video > Select track";
    }
    # mpv normalises hyphens in script names: quality-menu.lua is addressed as quality_menu.
    {
      command = "script-binding quality_menu/video_formats_toggle";
      menu = "Video > Stream quality";
    }
    {
      key = "s";
      command = "screenshot";
      menu = "Video > Screenshot with subtitles";
    }
    {
      key = "S";
      command = "screenshot video";
      menu = "Video > Screenshot video only";
    }
    {
      key = "f";
      command = "cycle fullscreen";
      menu = "Video > Toggle fullscreen";
    }
    {
      key = "r";
      command = "cycle_values video-rotate 90 180 270 0";
      menu = "Video > Rotate";
    }
    {
      key = "C";
      command = "script-binding autocrop/toggle_crop";
      menu = "Video > Toggle crop";
    }

    {
      key = "n";
      command = next;
      menu = "Navigation > Next";
    }
    {
      key = ">";
      command = next;
      menu = "Navigation > Next";
    }
    {
      key = "p";
      command = prev;
      menu = "Navigation > Previous";
    }
    {
      key = "<";
      command = prev;
      menu = "Navigation > Previous";
    }
    {
      command = "script-binding uosc/chapters";
      menu = "Navigation > Chapters";
    }
    {
      command = "script-binding uosc/editions";
      menu = "Navigation > Editions";
    }

    # Set both EOF options so switching modes does not inherit the previous pause policy.
    # These modes preserve the current pause state and reset on player restart.
    {
      command = "set keep-open-pause no; set keep-open always";
      menu = "Playback > Wait after each file";
    }
    {
      command = "set keep-open-pause yes; set keep-open yes";
      menu = "Playback > Auto-next, keep window";
    }
    {
      command = "set keep-open-pause yes; set keep-open no";
      menu = "Playback > Auto-next, exit at end";
    }

    # Profiles overwrite their options; A clears every GLSL shader, not just Anime4K.
    {
      key = "a";
      command = "apply-profile anime4k";
      menu = "Profiles > Anime4K";
    }
    {
      key = "A";
      command = "change-list glsl-shaders clr \"\"";
      menu = "Profiles > No shaders";
    }
    {
      command = "script-binding uosc/keybinds";
      menu = "Tools > Key bindings";
    }

    # Statistics
    {
      key = "i";
      command = "script-binding stats/display-page-1-toggle";
      menu = "Tools > Playback statistics";
    }
    {
      key = "I";
      command = "script-binding stats/display-page-5-toggle";
      menu = "Tools > File information";
    }
    {
      command = "script-binding commands/open";
      menu = "Tools > Command console";
    }

    {
      key = "q";
      command = "quit-watch-later";
      menu = "Quit > Save position and quit";
    }
    {
      key = "Q";
      command = "quit";
      menu = "Quit > Quit without saving";
    }
  ];

  # A missing key renders an unbound action that uosc can still expose via #!.
  renderBinding =
    {
      key ? null,
      command,
      menu ? null,
    }:
    "${if key == null then "#" else key} ${command}" + lib.optionalString (menu != null) " #! ${menu}";
in
{
  programs.mpv = {
    bindings = {
      # Arrow keys: seek by 5 seconds (Shift: 30), volume by 10; brackets adjust speed by 0.25.
      "left" = seek "-5";
      "right" = seek "5";
      "shift+left" = seek "-30";
      "shift+right" = seek "30";
      "up" = volume "10";
      "down" = volume "-10";
      "[" = speed "-0.25";
      "]" = speed "0.25";
      "\\" = "no-osd set speed 1; script-binding uosc/flash-speed";
      "space" = "cycle pause; script-binding uosc/flash-timeline";
      "WHEEL_DOWN" = volume "-2";
      "WHEEL_UP" = volume "2";

      # Vim-style navigation mirrors the arrows, with smaller volume steps (5 / 15).
      "h" = seek "-5";
      "l" = seek "5";
      "H" = seek "-30";
      "L" = seek "30";
      "k" = volume "5";
      "j" = volume "-5";
      "K" = volume "15";
      "J" = volume "-15";

      # Use one menu for daily controls; retain the built-in command console on `.
      "m" = "script-binding uosc/menu";
      "Alt+x" = "script-binding uosc/menu";
      "Ctrl+p" = "script-binding uosc/menu";
      "TAB" = "script-binding uosc/toggle-ui";

      # ignore default
      "9" = "ignore";
      "0" = "ignore";
    };

    extraInput = lib.concatMapStringsSep "\n" renderBinding entries;
  };
}

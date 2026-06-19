{ lib, pkgs, ... }:
{
  options.nixdefs.consts = lib.mkOption { type = lib.types.attrs; };
  config.nixdefs.consts = {
    niri.extraConfig = lib.mkDefault "";
    firefox.profileDir =
      if pkgs.stdenv.isDarwin then "Library/Application Support/Firefox" else ".config/mozilla/firefox";
    vicinae = {
      toggle = [
        "vicinae"
        "toggle"
      ];
      dmenu = [
        "vicinae"
        "dmenu"
      ];
      cliphist = [
        "vicinae"
        "deeplink"
        "vicinae://launch/clipboard/history"
      ];
      windows = [
        "vicinae"
        "deeplink"
        "vicinae://launch/wm/switch-windows"
      ];
      run = [
        "vicinae"
        "deeplink"
        "vicinae://launch/system/run"
      ];
      emoji = [
        "vicinae"
        "deeplink"
        "vicinae://launch/core/search-emojis"
      ];
    };
    noctalia =
      let
        ipc = [
          "noctalia"
          "msg"
        ];
      in
      {
        toggle = ipc ++ [
          "panel-toggle"
          "launcher"
        ];
        cliphist = ipc ++ [
          "panel-toggle"
          "clipboard"
        ];
        lock = ipc ++ [
          "session"
          "lock"
        ];
        session = ipc ++ [
          "panel-toggle"
          "session"
        ];
        volume = {
          up = ipc ++ [ "volume-up" ];
          down = ipc ++ [ "volume-down" ];
          mute = ipc ++ [ "volume-mute" ];
        };
        media = {
          playpause = ipc ++ [
            "media"
            "toggle"
          ];
          next = ipc ++ [
            "media"
            "next"
          ];
          prev = ipc ++ [
            "media"
            "previous"
          ];
        };
        brightness = {
          up = ipc ++ [ "brightness-up" ];
          down = ipc ++ [ "brightness-down" ];
        };
        powerProfile = ipc ++ [ "power-cycle" ];
        notifications = {
          toggle = ipc ++ [
            # "notifications" "toggleHistory"
          ];
          dnd = ipc ++ [ "notification-dnd-toggle" ];
          enableDND = ipc ++ [
            "notification-dnd-set"
            "on"
          ];
          disableDND = ipc ++ [
            "notification-dnd-set"
            "off"
          ];
          clear = ipc ++ [ "notification-clear-history" ];
          dismiss = ipc ++ [ "notification-clear-active" ];
        };
      };
    noctalia-v4 =
      let
        ipc = [
          "noctalia-shell"
          "ipc"
          "call"
        ];
      in
      {
        toggle = ipc ++ [
          "launcher"
          "toggle"
        ];
        cliphist = ipc ++ [
          "launcher"
          "clipboard"
        ];
        lock = ipc ++ [
          "lockScreen"
          "lock"
        ];
        session = ipc ++ [
          "sessionMenu"
          "toggle"
        ];
        volume = {
          up = ipc ++ [
            "volume"
            "increase"
          ];
          down = ipc ++ [
            "volume"
            "decrease"
          ];
          mute = ipc ++ [
            "volume"
            "muteOutput"
          ];
        };
        media = {
          playpause = [
            "media"
            "playPause"
          ];
          next = [
            "media"
            "next"
          ];
          prev = [
            "media"
            "previous"
          ];
        };
        brightness = {
          up = [
            "brightness"
            "increase"
          ];
          down = [
            "brightness"
            "decrease"
          ];
        };
        powerProfile = [
          "powerProfile"
          "cycle"
        ];
        notifications = {
          toggle = [
            "notifications"
            "toggleHistory"
          ];
          dnd = [
            "notifications"
            "toggleDND"
          ];
          enableDND = [
            "notifications"
            "enableDND"
          ];
          disableDND = [
            "notifications"
            "disableDND"
          ];
          clear = [
            "notifications"
            "clear"
          ];
          dismiss = [
            "notifications"
            "dismissAll"
          ];
        };
      };
    dank-material-shell =
      let
        ipc = [
          "dms"
          "ipc"
          "call"
        ];
      in
      {
        toggle = ipc ++ [
          "spotlight"
          "toggle"
        ];
        cliphist = ipc ++ [
          "clipboard"
          "toggle"
        ];
        lock = ipc ++ [
          "lock"
          "lock"
        ];
        session = ipc ++ [
          "powermenu"
          "toggle"
        ];
        volume = {
          up = ipc ++ [
            "audio"
            "increment"
            "3"
          ];
          down = ipc ++ [
            "audio"
            "decrement"
            "3"
          ];
          mute = ipc ++ [
            "audio"
            "mute"
          ];
        };
        media = {
          playpause = ipc ++ [
            "mpris"
            "playPause"
          ];
          next = ipc ++ [
            "mpris"
            "next"
          ];
          prev = ipc ++ [
            "mpris"
            "previous"
          ];
        };
        brightness = {
          up = ipc ++ [
            "brightness"
            "increment"
            "5"
            ""
          ];
          down = ipc ++ [
            "brightness"
            "decrement"
            "5"
            ""
          ];
        };
        notifications = {
          toggle = ipc ++ [
            "notifications"
            "toggle"
          ];
          dnd = ipc ++ [
            "notifications"
            "toggleDoNotDisturb"
          ];
          clear = ipc ++ [
            "notifications"
            "clearAll"
          ];
          dismiss = ipc ++ [
            "notifications"
            "dismissAllPopups"
          ];
        };
      };
  };
}

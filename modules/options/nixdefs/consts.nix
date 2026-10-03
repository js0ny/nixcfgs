{ lib, pkgs, ... }:
{
  options.nixdefs.consts = lib.mkOption { type = lib.types.attrs; };
  config.nixdefs.consts = {
    firefox.profileDir =
      if pkgs.stdenv.hostPlatform.isDarwin then
        "Library/Application Support/Firefox"
      else
        ".config/mozilla/firefox";
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
  };
}

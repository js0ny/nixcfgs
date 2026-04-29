{ lib, pkgs, ... }:
{
  options.nixdefs.consts = lib.mkOption { type = lib.types.attrs; };
  config.nixdefs.consts = {
    niri.extraConfig = lib.mkDefault "";
    firefox.profileDir =
      if pkgs.stdenv.isDarwin then
        "Library/Application Support/Firefox/Profiles"
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
    };
    noctalia =
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
  };
}

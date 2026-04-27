{ lib, pkgs, ... }:
{
  options.nixdefs.consts = lib.mkOption { type = lib.types.attrs; };
  config.nixdefs.consts = {
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
  };
}

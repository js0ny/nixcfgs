{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [
    pkgs.feishin
  ];
  mergetools.feishin-config = {
    target = "${config.home.homeDirectory}/.config/feishin/config.json";
    format = "json";
    settings = {
      theme = "system";
      window_has_frame = false;
      release_channel = "latest";
      global_media_hotkeys = true;
      window_window_bar_style = "windows";
      disable_auto_updates = true;
      lyrics = [
        "NetEase"
        "lrclib.net"
      ];
      # For window manager (hide on close)
      window_exit_to_tray = true;
      window_prevent_sleep_on_playback = true;
    };
  };
  nixdots.persist.home = {
    directories = [
      ".config/feishin"
    ];
  };
}

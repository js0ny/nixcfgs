{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc
      mpris
      thumbfast
      sponsorblock
      bdanmaku
    ];
    config = {
      vo = "gpu-next";
      hwdec = "auto-safe";
      keep-open = "always";
    };
    bindings = {
      "h" = "seek -5";
      "l" = "seek 5";
      "H" = "seek -30";
      "L" = "seek 30";
      "k" = "add volume 5";
      "j" = "add volume -5";
      "K" = "add volume 15";
      "J" = "add volume -15";
      "s" = "screenshot";
      "S" = "screenshot video";
      "f" = "cycle fullscreen";
      "n" = "playlist-next";
      "p" = "playlist-prev";
      "r" = "cycle_values video-rotate 90 180 270 0";
    };
  };
}

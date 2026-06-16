# https://github.com/tomasklaen/uosc
{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.features.media.mpv;
in
lib.mkIf cfg.enable {
  programs.mpv = {
    enable = true;
    scripts =
      with pkgs.mpvScripts;
      [
        # keep-sorted start
        autocrop
        bdanmaku
        memo
        quality-menu
        sponsorblock
        thumbfast
        uosc
        # keep-sorted end
        pkgs.misc.data.mpvScripts.bilibili-sponsorblock
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [ mpris ]);
    config = {
      vo = "gpu-next";
      hwdec = "auto-safe";
      # uosc recommended
      osd-bar = "no";
      border = "no";
      keep-open = "always";
    };
    bindings =
      let
        seek = val: "seek ${val}; script-binding uosc/flash-timeline";
        volume = val: "no-osd add volume ${val}; script-binding uosc/flash-volume";
        next = "script-binding uosc/next; script-message-to uosc flash-elements top_bar,timeline";
        prev = "script-binding uosc/prev; script-message-to uosc flash-elements top_bar,timeline";
        speed = val: "no-osd add speed ${val}; script-binding uosc/flash-speed";
      in
      {
        # Override default bindings
        "left" = seek "-5";
        "right" = seek "5";
        "shift+left" = seek "-30";
        "shift+right" = seek "30";
        "up" = volume "10";
        "down" = volume "-10";
        "[" = speed "-0.25";
        "]" = speed "0.25";
        "\\" = "no-osd set speed 1; script-binding uosc/flash-speed";
        ">" = next;
        "<" = prev;

        # Vim keys
        "h" = seek "-5";
        "l" = seek "5";
        "H" = seek "-30";
        "L" = seek "30";
        "k" = volume "5";
        "j" = volume "-5";
        "K" = volume "15";
        "J" = volume "-15";
        "n" = next;
        "p" = prev;

        "s" = "screenshot";
        "S" = "screenshot video";
        "f" = "cycle fullscreen";
        "r" = "cycle_values video-rotate 90 180 270 0";
        "m" = "script-binding uosc/menu";
        "TAB" = "script-binding uosc/toggle-ui";
        "P" = "script-binding uosc/items";
        "a" = "apply-profile anime4k";
        "A" = ''change-list glsl-shaders clr ""'';
        "Alt+x" = "script-binding uosc/menu";
      };
    profiles.anime4k = {
      glsl-shaders = [
        "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl"
        "${pkgs.anime4k}/Anime4K_Restore_CNN_VL.glsl"
        "${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl"
        "${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl"
        "${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl"
      ];
    };
  };
}

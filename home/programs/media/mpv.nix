{ pkgs, lib, ... }:
{
  programs.mpv = {
    enable = true;
    scripts =
      with pkgs.mpvScripts;
      [
        # keep-sorted start
        autocrop
        bdanmaku
        quality-menu
        sponsorblock
        thumbfast
        uosc
        # keep-sorted end
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [ mpris ]);
    config = {
      vo = "gpu-next";
      hwdec = "auto-safe";
      # keep-open = "always";
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
      "m" = "script-binding uosc/menu";
      "TAB" = "script-binding uosc/toggle-ui";
      "P" = "script-binding uosc/items";
      "a" = "apply-profile anime4k";
      "A" = ''change-list glsl-shaders clr ""'';
    };
    profiles.anime4k = {
      glsl-shaders = [
        "${pkgs.anime4k}/glsl/Anime4K_Clamp_Highlights.glsl"
        "${pkgs.anime4k}/glsl/Anime4K_Restore_CNN_VL.glsl"
        "${pkgs.anime4k}/glsl/Anime4K_Upscale_CNN_x2_VL.glsl"
        "${pkgs.anime4k}/glsl/Anime4K_AutoDownscalePre_x2.glsl"
        "${pkgs.anime4k}/glsl/Anime4K_AutoDownscalePre_x4.glsl"
        "${pkgs.anime4k}/glsl/Anime4K_AutoDownscalePost_x2.glsl"
        "${pkgs.anime4k}/glsl/Anime4K_AutoDownscalePost_x4.glsl"
      ];
    };
  };
}

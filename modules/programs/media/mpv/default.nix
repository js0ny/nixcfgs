# https://github.com/tomasklaen/uosc
{
  flake.homeModules.mpv =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ ./controls.nix ];

      programs.mpv = {
        enable = true;

        # uosc provides the player UI; thumbfast supplies its timeline thumbnails.
        # The remaining scripts add cropping, danmaku, bookmarks, history, stream quality and sponsor skipping.
        scripts =
          with pkgs.mpvScripts;
          [
            # keep-sorted start
            autocrop
            bdanmaku
            eisa01.simplebookmark
            memo
            quality-menu
            sponsorblock
            thumbfast
            uosc
            # keep-sorted end
            pkgs.js0ny.mpvScripts.bilibili-sponsorblock
          ]
          # Expose playback controls to desktop media keys and MPRIS clients on Linux.
          ++ (lib.optionals pkgs.stdenv.hostPlatform.isLinux [ mpris ]);

        config = {
          # Use the libplacebo renderer and conservative automatic hardware decoding.
          vo = "gpu-next";
          hwdec = "auto-safe";

          # Let uosc draw the indicators and window controls instead of duplicating them.
          osd-bar = "no";
          border = "no";

          # Wait at every EOF, including intermediate playlist entries, without setting pause.
          # This lets n advance normally after EOF while preserving a manual pause.
          keep-open = "always";
          keep-open-pause = "no";
        };

        # a applies this profile at runtime; it is not enabled by default.
        profiles.anime4k = {
          # Preserve pipeline order: clamp highlights, restore detail, upscale, then conditionally downscale.
          glsl-shaders = [
            "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl"
            "${pkgs.anime4k}/Anime4K_Restore_CNN_VL.glsl"
            "${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl"
            "${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl"
            "${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl"
          ];
        };

        # Written to script-opts/<script>.conf, separate from the main mpv configuration.
        scriptOpts = {
          autocrop = {
            # Detect black bars only on request: dark opening scenes can cause incorrect crops.
            # Note: autocrop makes the video feel inconsistent on start
            auto = false;
          };
          memo = {
            history_path = "${config.xdg.stateHome}/mpv/memo-history.log";
          };
          uosc = {
            # Reverse wheel seeking only over the timeline; elsewhere the wheel changes volume.
            timeline_step = "-5";
          };
        };
      };

      # memo opens its log directly and does not create the parent directory.
      systemd.user.tmpfiles.rules = [
        "d ${config.xdg.stateHome}/mpv 0700 - - -"
      ];
    };
}

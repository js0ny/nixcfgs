{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
let
  bbdown-wrapped = pkgs.writeShellApplication {
    name = "BBDown";
    text = ''
      has_config_file=0
      for arg in "$@"; do
        if [ "$arg" = "--config-file" ]; then
          has_config_file=1
          break
        fi
      done

      if [ "$has_config_file" -eq 1 ]; then
        exec ${lib.getExe pkgs.localPkgs.BBDown} "$@"
      fi

      exec ${lib.getExe pkgs.localPkgs.BBDown} \
        --config-file ${config.sops.templates."BBDown.config".path} \
        "$@"
    '';
  };
in
{
  sops.secrets = {
    bilibili_sessdata = {
      sopsFile = secrets + /net.yaml;
    };
  };
  sops.templates."BBDown.config".content = ''
    --delay-per-page
    2
    --cookie
    SESSDATA=${config.sops.placeholder.bilibili_sessdata}
    --download-danmaku
  '';
  home.packages =
    with pkgs;
    [
      # keep-sorted start
      bbdown-wrapped
      exiftool
      flac
      localPkgs.danmaku2ass
      localPkgs.mediatools.extract-audio
      localPkgs.mediatools.preview-by-orientation
      localPkgs.mediatools.remux-mp4
      localPkgs.mediatools.smart-media-converter
      localPkgs.mediatools.to-av1
      localPkgs.mediatools.to-av1-mp4
      localPkgs.mediatools.to-avif
      localPkgs.mediatools.to-webp
      localPkgs.mediatools.video-gen-grid
      mediainfo
      yt-dlp
      # keep-sorted end
    ]
    ++ lib.optionals (config.nixdots.desktop.enable) [
      picard
      kid3
    ];
}

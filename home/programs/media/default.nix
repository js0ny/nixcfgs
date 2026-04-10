{
  pkgs,
  config,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      flac
      mediainfo
      exiftool
      yt-dlp
      localPkgs.mediatools.extract-audio
      localPkgs.mediatools.preview-by-orientation
      localPkgs.mediatools.remux-mp4
      localPkgs.mediatools.smart-media-converter
      localPkgs.mediatools.to-av1
      localPkgs.mediatools.to-av1-mp4
      localPkgs.mediatools.to-avif
      localPkgs.mediatools.to-webp
      localPkgs.mediatools.video-gen-grid
    ]
    ++ (
      if config.nixdots.desktop.enable then
        with pkgs;
        [
          picard
          kid3
        ]
      else
        [ ]
    );
}

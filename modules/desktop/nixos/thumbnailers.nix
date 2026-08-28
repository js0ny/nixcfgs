{ pkgs, ... }: {
  # https://wiki.nixos.org/wiki/Thumbnails
  environment.pathsToLink = [ "share/thumbnailers" ];
  environment.systemPackages = with pkgs; [
    # Video
    ffmpeg-headless
    ffmpegthumbnailer
    # Image
    gdk-pixbuf
    libheif.bin
    libheif.out
    libavif
    libjxl
    webp-pixbuf-loader
    # 3D Models
    # f3d
  ];
}

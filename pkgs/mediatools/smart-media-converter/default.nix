{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "smart-media-converter";
  runtimeInputs = with pkgs; [
    python3
    imagemagick
    fd
    ffmpeg
  ];
  text = ''
    exec python3 ${./smart-media-converter.py} "$@"
  '';
}

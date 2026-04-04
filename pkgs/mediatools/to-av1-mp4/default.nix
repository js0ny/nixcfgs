{pkgs, ...}:
pkgs.writeShellApplication {
  name = "to-av1-mp4";
  runtimeInputs = with pkgs; [
    ffmpeg
  ];
  text = builtins.readFile ./to-av1-mp4.sh;
}

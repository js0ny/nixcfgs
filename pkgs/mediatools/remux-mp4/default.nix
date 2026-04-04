{pkgs, ...}:
pkgs.writeShellApplication {
  name = "remux-mp4";
  runtimeInputs = with pkgs; [
    ffmpeg
  ];
  text = builtins.readFile ./remux-mp4.sh;
}

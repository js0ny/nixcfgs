{pkgs, ...}:
pkgs.writeShellApplication {
  name = "extract-audio";
  runtimeInputs = with pkgs; [
    ffmpeg
    gawk
  ];
  text = builtins.readFile ./extract-audio.sh;
}

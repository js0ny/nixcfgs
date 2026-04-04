{pkgs, ...}:
pkgs.writeShellApplication {
  name = "to-av1";
  runtimeInputs = with pkgs; [
    ffmpeg
  ];
  text = builtins.readFile ./to-av1.sh;
}

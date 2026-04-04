{pkgs, ...}:
pkgs.writeShellApplication {
  name = "video-gen-grid";
  runtimeInputs = with pkgs; [
    ffmpeg
    gawk
  ];
  text = builtins.readFile ./gen-grid.sh;
}

{pkgs, ...}:
pkgs.writeShellApplication {
  name = "preview-by-orientation";
  runtimeInputs = with pkgs; [
    imagemagick
  ];
  text = builtins.readFile ./preview-by-orientation.sh;
}

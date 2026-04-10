{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "to-webp";
  runtimeInputs = with pkgs; [
    exiftool
    imagemagick
  ];
  text = builtins.readFile ./to-webp.sh;
}

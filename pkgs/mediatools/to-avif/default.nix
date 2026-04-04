{pkgs, ...}:
pkgs.writeShellApplication {
  name = "to-avif";
  runtimeInputs = with pkgs; [
    imagemagick
  ];
  text = builtins.readFile ./to-avif.sh;
}

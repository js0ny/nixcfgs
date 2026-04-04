# https://github.com/sentriz/cliphist/blob/master/contrib/cliphist-rofi-img
{pkgs, ...}:
pkgs.writeShellApplication {
  name = "rofi-img-cliphist";
  runtimeInputs = with pkgs; [cliphist];
  text = builtins.readFile ./rofi-img-cliphist.sh;
}

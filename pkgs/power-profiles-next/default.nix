{pkgs, ...}:
pkgs.writeShellApplication {
  name = "power-profiles-next";
  runtimeInputs = with pkgs; [power-profiles-daemon libnotify];
  text = builtins.readFile ./power-profiles-next.sh;
}

{pkgs, ...}:
pkgs.writeShellApplication {
  name = "rename-zero-pad";
  runtimeInputs = with pkgs; [
    python3
  ];
  text = ''
    exec python3 ${./rename-zero-pad.py} "$@"
  '';
}

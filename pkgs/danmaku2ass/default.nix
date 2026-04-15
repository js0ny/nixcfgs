{ pkgs, ... }:
let
  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/m13253/danmaku2ass/refs/heads/master/danmaku2ass.py";
    sha256 = "sha256-iZUmt6jzGrIJh73OvFQ/Z76azNzsYSDSDznPxO+gAc8=";
  };
in
pkgs.writeShellApplication {
  name = "danmaku2ass";
  runtimeInputs = with pkgs; [
    python3
  ];
  text = ''
    exec python3 ${src} "$@"
  '';
}

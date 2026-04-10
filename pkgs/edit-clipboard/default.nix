{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "edit-clipboard";
  runtimeInputs =
    with pkgs;
    [
      coreutils
    ]
    ++ lib.optionals stdenv.isLinux [
      wl-clipboard
      libnotify
      xclip
      xsel
    ];
  text = builtins.readFile ./edit-clipboard.sh;
}

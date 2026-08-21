{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "edit-clipboard";
  runtimeInputs =
    with pkgs;
    [
      coreutils
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wl-clipboard
      libnotify
    ];
  text = builtins.readFile ./edit-clipboard.sh;
}

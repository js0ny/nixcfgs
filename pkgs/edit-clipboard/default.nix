{ lib, pkgs, ... }:
pkgs.writers.writeNuBin "edit-clipboard" {
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath (
      with pkgs;
      [
        coreutils
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        libnotify
        wl-clipboard
      ]
    ))
  ];
} (builtins.readFile ./edit-clipboard.nu)

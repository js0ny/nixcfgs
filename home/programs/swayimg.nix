{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  programs.swayimg = {
    enable = true;
  };
}

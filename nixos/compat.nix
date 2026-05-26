{
  pkgs,
  lib,
  config,
  ...
}:
let
  m = config.nixdots.machine;
in
lib.mkIf m.compat {
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
    ];
  };
}

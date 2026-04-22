{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  home.packages = with pkgs; [
    quickemu
  ];
  nixdots.persist.home = {
    directories = [
      "VMs"
    ];
  };
}

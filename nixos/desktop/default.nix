{ pkgs, ... }:
{
  imports = [
    # keep-sorted start
    ../.
    ../hardware/audio.nix
    ./base.nix
    ./de
    ./dm
    ./gnome-keyring.nix
    ./gui.nix
    ./input
    ./lanzaboote.nix
    ./laptop.nix
    ./networkmanager.nix
    ./packages.nix
    ./wayland.nix
    ./wsl.nix
    # keep-sorted end
  ];
  nixdefs.hardware.enable = true;
  programs.appimage.enable = true;
}

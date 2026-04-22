{ pkgs, ... }:
{
  imports = [
    ./gnome-keyring.nix
    ./tuned.nix
    ./diskutil.nix
    ./laptop.nix
    ./base.nix
    ./core.nix
    ./wayland.nix
    ./keyd.nix
    ./xremap.nix
    ./dm
    ./de
    ../hardware/audio.nix
    ./networkmanager.nix
    ../default.nix
  ];
  nixdefs.hardware.enable = true;
}

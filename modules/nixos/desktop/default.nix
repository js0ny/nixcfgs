{ pkgs, ... }:
{
  imports = [
    # keep-sorted start
    ../default.nix
    ../hardware/audio.nix
    ./base.nix
    ./core.nix
    ./de
    ./diskutil.nix
    ./dm
    ./gnome-keyring.nix
    ./keyd.nix
    ./laptop.nix
    ./networkmanager.nix
    ./wayland.nix
    ./xremap.nix
    # keep-sorted end
  ];
  nixdefs.hardware.enable = true;
}

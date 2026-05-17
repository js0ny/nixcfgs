{ pkgs, ... }:
{
  imports = [
    # keep-sorted start
    ../.
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
    ./packages.nix
    ./wayland.nix
    ./xremap.nix
    # keep-sorted end
  ];
  nixdefs.hardware.enable = true;
}

{pkgs, ...}: {
  imports = [
    ./gnome-keyring.nix
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
  ];
}

_: {
  imports = [
    # keep-sorted start
    ../.
    ./base.nix
    ./desktop-sessions.nix
    ./display-manager.nix
    ./audio.nix
    ./peripherals.nix
    ./bluetooth.nix
    ./gnome-keyring.nix
    ./gui.nix
    ./i2c.nix
    ./input
    ./lanzaboote.nix
    ./laptop.nix
    ./networkmanager.nix
    ./packages.nix
    ./wayland.nix
    ./firmware.nix
    # keep-sorted end
  ];
  nixdefs.hardware.enable = true;
  programs.appimage.enable = true;
}

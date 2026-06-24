_: {
  imports = [
    # keep-sorted start
    ../.
    ./audio.nix
    ./base.nix
    ./bluetooth.nix
    ./desktop-sessions.nix
    ./display-manager.nix
    ./firmware.nix
    ./gnome-keyring.nix
    ./gui.nix
    ./i2c.nix
    ./input
    ./lanzaboote.nix
    ./laptop.nix
    ./networkmanager.nix
    ./packages.nix
    ./peripherals.nix
    ./wayland.nix
    # keep-sorted end
  ];
  nixdefs.hardware.enable = true;
  programs.appimage.enable = true;
}

{ ... }:
{
  imports = [
    # keep-sorted start
    ./asus.nix
    ./audio.nix
    ./bluetooth.nix
    ./hid.nix
    ./nvidia
    ./peripherals.nix
    ./serial.nix
    ./uinput.nix
    # keep-sorted end
  ];
  hardware.enableRedistributableFirmware = true;
}

{ ... }:
{
  imports = [
    # keep-sorted start
    ./asus.nix
    ./audio.nix
    ./hid.nix
    ./nvidia
    ./serial.nix
    ./uinput.nix
    # keep-sorted end
  ];
  hardware.enableRedistributableFirmware = true;
}

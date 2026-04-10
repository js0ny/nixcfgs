{ ... }:
{
  imports = [
    ./asus.nix
    ./audio.nix
    ./serial.nix
    ./uinput.nix
    ./hid.nix
    ./nvidia
  ];
  hardware.enableRedistributableFirmware = true;
}

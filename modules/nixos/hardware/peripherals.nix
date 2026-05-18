{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ evtest ];
  hardware = {
    keyboard.qmk.enable = true;
    # XBox Series Bluetooth Controller
    xpadneo.enable = true;
    steam-hardware.enable = true;
  };
}

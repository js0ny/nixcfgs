{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.enable;
in
lib.mkIf cfg {
  environment.systemPackages = with pkgs; [ evtest ];
  hardware = {
    keyboard.qmk.enable = true;
    # XBox Series Bluetooth Controller
    xpadneo.enable = true;
    steam-hardware.enable = true;
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
  services.logiops.enable = true;
  # disable xpad to prevent conflicts with xpadneo
  boot.blacklistedKernelModules = [ "xpad" ];
}

{ pkgs, config, ... }:
let
  user = config.nixdots.user.name;
in
{
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
  programs.librepods.enable = true;
  users.users.${user}.extraGroups = [ "librepods" ];
}

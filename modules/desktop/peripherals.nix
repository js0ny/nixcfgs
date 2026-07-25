{
  pkgs,
  lib,
  config,
  ...
}:
let
  user = config.nixdots.user.name;
in
{
  environment.systemPackages = with pkgs; [
    evtest
    js0ny.openlogi
    js0ny.openlogi-gui
  ];

  services.udev.packages = [ pkgs.js0ny.openlogi-agent ];
  systemd.user.services.openlogi-agent = {
    description = "OpenLogi background agent";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = lib.getExe pkgs.js0ny.openlogi-agent;
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
  hardware = {
    keyboard.qmk.enable = true;
    # XBox Series Bluetooth Controller
    xpadneo.enable = true;
    steam-hardware.enable = true;
  };
  # disable xpad to prevent conflicts with xpadneo
  boot.blacklistedKernelModules = [ "xpad" ];
  programs.librepods.enable = true;
  users.users.${user}.extraGroups = [ "librepods" ];

  # TODO: Try OpenLogi
  # services.logiops.enable = true;
  # logitech.wireless = {
  #   enable = true;
  #   enableGraphical = true;
  # };
}

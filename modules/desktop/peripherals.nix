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
    openlogi
  ];

  services.udev.packages = [ pkgs.openlogi ];
  systemd.user.services.openlogi-agent = {
    description = "OpenLogi background agent";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = lib.getExe' pkgs.openlogi "openlogi-agent";
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

}

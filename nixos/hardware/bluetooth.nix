{ lib, config, ... }:
let
  cfg = config.nixdots.desktop.enable;
in
lib.mkIf cfg {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "dual";
        JustWorksRepairing = "confirm";
      };
    };
  };

  nixdots.persist.system = {
    directories = [
      "/var/lib/bluetooth"
    ];
  };
}

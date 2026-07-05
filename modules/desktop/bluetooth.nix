_: {
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

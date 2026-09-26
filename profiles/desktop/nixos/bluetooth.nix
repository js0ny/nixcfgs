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

  js0ny.persist.stores.state.directories = [ "/var/lib/bluetooth" ];
}

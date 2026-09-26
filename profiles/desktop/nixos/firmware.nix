{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.fwupd.enable = true;
  systemd.timers.fwupd-refresh.enable = false;
  environment.systemPackages = lib.optionals (config.hardware.graphics.enable) [
    pkgs.gnome-firmware
  ];

  js0ny.persist.stores.state.directories = [ "/var/lib/fwupd" ];
}

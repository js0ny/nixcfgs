{ config, lib, ... }:
let
  cfg = config.nixdefs.hardware;
  # peripheral:
  # * group: plugdev
  peripheral = config.nixdefs.hardware.peripheral;
  keyboard = peripheral.keyboard;
  username = config.nixdots.user.name;
  viaKeyboards = lib.filterAttrs (_: kbd: kbd.via) keyboard;
  keyboardRules = lib.mapAttrsToList (_: device: ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="${device.dev.vendorId}", ATTRS{idProduct}=="${device.dev.productId}", SUBSYSTEM=="hidraw", GROUP="${peripheral.group}", MODE="0660"
  '') viaKeyboards;
in
lib.mkIf cfg.enable {
  # WebUSB support for Via configuration
  # 19f5: Nuphy Keyboards
  services.udev.extraRules = lib.concatStringsSep "\n" keyboardRules;

  users.groups."${peripheral.group}" = { };

  users.users."${username}" = {
    extraGroups = [ "${peripheral.group}" ];
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdefs.hardware;
  # serial:
  # * group: dialout
  serial = config.nixdefs.hardware.serial;
  username = config.nixdots.user.name;
  serialRules = lib.mapAttrsToList (_: device: ''
    ATTRS{idVendor}=="${device.dev.vendorId}", ATTRS{idProduct}=="${device.dev.productId}", MODE="0660", GROUP="${serial.group}", SYMLINK+="${device.symlink}"
  '') serial.device;
in
lib.mkIf cfg.enable {
  services.udev.extraRules = lib.concatStringsSep "\n" serialRules;

  users.groups."${serial.group}" = { };

  users.users."${username}" = {
    extraGroups = [ "${serial.group}" ];
  };
}

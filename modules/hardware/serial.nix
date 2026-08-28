{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdefs.hardware;
  # serial:
  # * group: dialout
  serial = {
    basys3 = {
      dev.vendorId = "0403";
      dev.productId = "6010";
      symlink = "basys3";
    };
  };
  username = config.nixdots.user.name;
  serialRules = lib.mapAttrsToList (_: device: /* udev */ ''
    ATTRS{idVendor}=="${device.dev.vendorId}", ATTRS{idProduct}=="${device.dev.productId}", MODE="0660", GROUP="dialout", SYMLINK+="${device.symlink}"
  '') serial;
in
lib.mkIf cfg.enable {
  services.udev.extraRules = lib.concatStringsSep "\n" serialRules;

  users.groups.dialout = { };

  users.users."${username}" = {
    extraGroups = [ "dialout" ];
  };
}

{
  config,
  lib,
  ...
}:
let
  username = config.nixdots.user.name;
  serial = {
    # Xilinx Artix-7 Basys 3
    # See: https://www.devicekb.com/hardware/usb-vendors/vid_0403-pid_6010
    basys3 = {
      idVendor = "0403";
      idProduct = "6010";
      symlink = "basys3";
    };
  };
  serialRules = lib.mapAttrsToList (_: device: ''
    ATTRS{idVendor}=="${device.idVendor}", ATTRS{idProduct}=="${device.idProduct}", MODE="0660", GROUP="dialout", SYMLINK+="${device.symlink}"
  '') serial;
in
{
  services.udev.extraRules = lib.concatStringsSep "\n" serialRules;
  users.users."${username}" = {
    extraGroups = [ "dialout" ];
  };
}

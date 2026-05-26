# https://www.devicekb.com/hardware/usb-vendors
{ lib, config, ... }:
let
  cfg = config.nixdefs.hardware;
  devType = lib.types.submodule {
    options = {
      vendorId = lib.mkOption {
        type = lib.types.str;
        example = "0403";
        description = "USB Vendor ID (4 hex digits)";
      };
      productId = lib.mkOption {
        type = lib.types.str;
        example = "6010";
        description = "USB Product ID (4 hex digits)";
      };
    };
  };
  serialDevType = lib.types.submodule (
    { name, ... }:
    {
      options = {
        dev = lib.mkOption {
          type = devType;
        };
        symlink = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "Link the device to /dev/SYMLINK";
        };
      };
    }
  );
  keyboardType = lib.types.submodule {
    options = {
      dev = lib.mkOption {
        type = devType;
      };
      paths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "/dev/input/by-id/PATH";
      };
      qmk = lib.mkOption {
        type = lib.types.bool;
      };
      via = lib.mkOption {
        type = lib.types.bool;
      };
    };
  };
in
{
  options.nixdefs.hardware = {
    enable = lib.mkEnableOption "Hardware Rules applications";
    serial = {
      group = lib.mkOption {
        type = lib.types.str;
        default = "dialout";
        description = "group that can access to serial devices";
      };
      device = lib.mkOption {
        type = lib.types.attrsOf serialDevType;
        default = { };
      };
    };
    peripheral = {
      group = lib.mkOption {
        type = lib.types.str;
        default = "plugdev";
        description = "group that can access to hid/peripheral devices";
      };
      keyboard = lib.mkOption {
        type = lib.types.attrsOf keyboardType;
        default = { };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    nixdefs.hardware = {
      serial.device = {
        basys3 = {
          dev.vendorId = "0403";
          dev.productId = "6010";
          symlink = "basys3";
        };
      };
      peripheral.keyboard = {
        "NuPhy Air 75 V2" = {
          dev.vendorId = "19f5";
          dev.productId = "3246";
          paths = [
            "usb-Nordic_Semiconductor_NuPhy_Air75_V2_Dongle-event-kbd"
            "usb-Nordic_Semiconductor_NuPhy_Air75_V2_Dongle-hidraw"
            "usb-Nordic_Semiconductor_NuPhy_Air75_V2_Dongle-if01-event-kbd"
            "usb-Nordic_Semiconductor_NuPhy_Air75_V2_Dongle-if01-event-mouse"
            "usb-Nordic_Semiconductor_NuPhy_Air75_V2_Dongle-if01-hidraw"
            "usb-Nordic_Semiconductor_NuPhy_Air75_V2_Dongle-if01-mouse"
            "usb-Nordic_Semiconductor_NuPhy_Air75_V2_Dongle-if02-hidraw"
            "usb-NuPhy_NuPhy_Air75_V2-event-if01"
            "usb-NuPhy_NuPhy_Air75_V2-event-kbd"
            "usb-NuPhy_NuPhy_Air75_V2-hidraw"
            "usb-NuPhy_NuPhy_Air75_V2-if01-event-joystick"
            "usb-NuPhy_NuPhy_Air75_V2-if01-event-kbd"
            "usb-NuPhy_NuPhy_Air75_V2-if01-event-mouse"
            "usb-NuPhy_NuPhy_Air75_V2-if01-hidraw"
            "usb-NuPhy_NuPhy_Air75_V2-if01-mouse"
            "usb-NuPhy_NuPhy_Air75_V2-if02-hidraw"
          ];
          qmk = true;
          via = true;
        };
      };
    };
  };
}

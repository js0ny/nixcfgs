{ lib, ... }:
let
  typing = import ./types.nix { inherit lib; };
in
{
  options.nixdots.laptop = {
    enable = lib.mkEnableOption "Enable laptop-specific configurations and optimizations.";
    asus = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable ASUS-specifc configurations and asus-linux tools.";
    };
    display = lib.mkOption {
      type = typing.laptopDisplay;
      example = {
        connector = "eDP-1";
        makeModel = "Samsung Display Corp. ATNA40CU05-0  Unknown";
        VRR = true;
      };
    };
    keyboard = lib.mkOption {
      type = typing.inputDevice;
      example = {
        devicePath = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        name = "AT Translated Set 2 keyboard";
        vendorId = "0001";
        productId = "0001";
      };
    };
    touchpad = lib.mkOption {
      type = typing.inputDevice;
      example = {
        devicePath = "/dev/input/by-path/platform-AMDI0010:00-event-mouse";
        name = "ASUP1208:00 093A:3011 Touchpad";
        vendorId = "093A";
        productId = "3011";
      };
    };
    backlight = {
      screen = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "intel_backlight";
        description = "Sysfs interface for the built-in screen backlight.";
      };
      keyboard = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "asus::kbd_backlight";
        description = "Sysfs interface for the built-in keyboard backlight.";
      };
    };
    microphone = lib.mkOption {
      type = typing.audioDevice;
      default = {
        name = "";
        description = "";
      };
      example = {
        name = "alsa_input.pci-0000_65_00.6.analog-stereo";
        description = "内置麦克风";
      };
    };
    cameraIR = {
      # use mpv av://v4l2:/dev/video0 to test the IR camera feed
      devicePath = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "/dev/video0";
        description = "Device path for the built-in IR camera used for facial recognition.";
      };
    };
  };
}

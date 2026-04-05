{lib, ...}: let
  appType = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "The package to install for this application.";
      };
      exe = lib.mkOption {
        type = lib.types.str;
        description = "The executable name for this application";
      };
      desktop = lib.mkOption {
        type = lib.types.str;
        description = ''
          The desktop file name for this application on Linux(with .desktop suffix).
          Or Apple .app bundle name on macOS (with .app suffix).
        '';
      };
      bundleIdentifier = lib.mkOption {
        type = lib.types.str;
        description = "The bundle identifier for this application (macOS only).";
      };
    };
  };
  fontType = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "The font package to install.";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The human-readable name of the font.";
      };
    };
  };
  cursorType = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "The cursor theme package to install.";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the cursor theme.";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 24;
        description = "The size of the cursor in pixels.";
      };
    };
  };
  iconType = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "The icon theme package to install.";
      };
      light = lib.mkOption {
        type = lib.types.str;
        description = "The name of the light icon theme.";
      };
      dark = lib.mkOption {
        type = lib.types.str;
        description = "The name of the dark icon theme.";
      };
    };
  };
  laptopDisplay = lib.types.submodule {
    options = {
      connector = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "eDP-1";
        description = "DRM connector name.";
      };
      makeModel = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "Samsung Display Corp. ATNA40CU05-0";
        description = "EDID Make and Model string for human documentation.";
      };
      VRR = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the display supports Variable Refresh Rate (VRR).";
      };
    };
  };
  inputDevice = lib.types.submodule {
    options = {
      devicePath = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        description = "Absolute evdev path (usually in by-path or by-id).";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "AT Translated Set 2 keyboard";
        description = "The exact device name exposed by evdev/libinput.";
      };

      vendorId = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "0001";
        description = "Vendor ID (hex). Often 0001 for internal PS/2 keyboards.";
      };

      productId = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "0001";
        description = "Product ID (hex).";
      };
    };
  };
  audioDevice = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "alsa_input.pci-0000_00_1f.3.analog-stereo";
        description = "PipeWire node.name for the audio device.";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "Built-in Audio Analog Stereo";
        description = "Human-readable node.description for documentation. Setting this will rename the device in PipeWire to this description, so it should be unique among all devices.";
      };
    };
  };
in {
  inherit appType fontType cursorType iconType laptopDisplay inputDevice audioDevice;
}

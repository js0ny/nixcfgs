{ config, lib, ... }:
let
  keyboard = config.nixdefs.hardware.peripheral.keyboard;
  qmkKeyboards = lib.filterAttrs (_: kbd: kbd.qmk) keyboard;
  qmkPaths = builtins.concatLists (lib.mapAttrsToList (_: kbd: kbd.paths) qmkKeyboards);
  # Use global keymaps
  qmkInputs = map (name: "/dev/input/by-id/" + name) qmkPaths;
in
{
  services.xremap.config.modmap = [
    {
      name = "Global";
      device = {
        not = qmkInputs;
      };
      remap = {
        "KEY_CAPSLOCK" = {
          held = "KEY_LEFTCTRL";
          alone = "KEY_ESC";
          free_hold = true;
        };
      };
    }
  ];
}

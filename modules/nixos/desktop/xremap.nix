{
  config,
  lib,
  ...
}:
let
  keyboard = config.nixdefs.hardware.peripheral.keyboard;
  qmkKeyboards = lib.filterAttrs (_: kbd: kbd.qmk) keyboard;
  _qmkInputs = builtins.concatLists (lib.mapAttrsToList (_: kbd: kbd.paths) qmkKeyboards);
  # Use global keymaps
  qmkInputs = map (name: "/dev/input/by-id/" + name) _qmkInputs;
  username = config.nixdots.user.name;
  cfg = config.nixdots.desktop.xremap.enable;
in
{
  # Keycode: https://github.com/emberian/evdev/blob/1d020f11b283b0648427a2844b6b980f1a268221/src/scancodes.rs#L15
  # Alias for mods:
  #     SHIFT-
  #     CTRL-, C-, CONTROL-
  #     ALT-, M-
  #     WIN-, SUPER-, WINDOWS-

  services.xremap = {
    enable = cfg;
    withNiri = true;
    # modmap: single key
    serviceMode = "user";
    userName = username;
    config = {
      modmap = [
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
        {
          # Mouse Key code:
          # * BTN_EXTRA -> Forward button
          # * BTN_SIDE  -> Back button
          name = "Mouse";
          device = {
            not = qmkInputs;
          };
          remap = {
            "BTN_EXTRA" = "KEY_ENTER";
          };
        }
      ];
      keymap = [
        {
          name = "IM Navigator - Alt-Up/Down";
          application = {
            only = [
              "wechat"
            ];
          };
          remap = {
            "M-j" = "M-down";
            "M-k" = "M-up";
          };
        }
        {
          name = "IM Navigator - Ctrl-Up/Down";
          application = {
            only = [ "QQ" ];
          };
          remap = {
            "M-j" = "C-down";
            "M-k" = "C-up";
          };
        }
        {
          name = "Zotero PDF Navigator";
          application = {
            only = [ "Zotero" ];
          };
          remap = {
            "M-j" = "KEY_PAGEDOWN";
            "M-k" = "KEY_PAGEUP";
          };
        }
      ];
    };
  };

  # treat the virtual keyboard as internal
  # https://github.com/xremap/xremap/discussions/656
  environment.etc."libinput/local-overrides.quirks".text = ''
    [xremap]
    MatchName=xremap
    MatchUdevType=keyboard
    AttrKeyboardIntegration=internal
  '';
}

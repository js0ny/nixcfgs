# Reference: https://github.com/xremap/nix-flake/blob/master/docs/HOWTO.md
{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.nixdots.keymaps.xremap;
in
{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];
  # Keycode: https://github.com/emberian/evdev/blob/1d020f11b283b0648427a2844b6b980f1a268221/src/scancodes.rs#L15
  # Alias for mods:
  #     SHIFT-
  #     CTRL-, C-, CONTROL-
  #     ALT-, M-
  #     WIN-, SUPER-, WINDOWS-
  services.xremap = {
    enable = cfg.enable;
    withNiri = true;
  };

  systemd.user.services.xremap.Install.WantedBy = lib.mkForce [ "niri.service" ];
}

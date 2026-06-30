# Reference: https://github.com/xremap/nix-flake/blob/master/docs/HOWTO.md
{
  lib,
  inputs,
  ...
}:
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
    enable = true;
    # withNiri = true;
    withHypr = true;

  };

  systemd.user.services.xremap = {
    Unit = {
      PartOf = [ "waylandwm-session.target" ];
      After = [ "waylandwm-session.target" ];
    };
    Install.WantedBy = lib.mkForce [ "waylandwm-session.target" ];
  };
}

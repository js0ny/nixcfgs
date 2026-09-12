{
  lib,
  config,
  ...
}:
{
  options.js0ny.desktop = {
    enable = lib.mkEnableOption "Whether to enable desktop environment modules. This is a global toggle that can be overridden by specific desktop manager modules if needed.";
    display = lib.mkOption {
      type = lib.types.enum [
        "wayland"
        "none"
      ];
      default = "none";
      description = ''
        The display protocol to use. 'wayland' for Wayland, and 'none' for headless setups. This can be overridden by specific desktop manager modules if needed.
      '';
    };
    displayManager = lib.mkOption {
      type = lib.types.enum [
        "macos"
        "ly"
        "gdm"
        "sddm"
        "cosmic-greeter"
        "plasma-login-manager"
        "regreet"
        "none"
      ];
      default = if config.js0ny.desktop.display == "none" then "none" else "ly";
      description = "The display manager to use.";
    };
    autoLogin = lib.mkEnableOption "Whether to login automatically";
    session = lib.mkOption {
      type =
        with lib.types;
        listOf (enum [
          "niri"
          "hyprland"
          "sway"
          "kde"
          "gnome"
          "cosmic"
          "none"
          "macos"
        ]);
      # clear default session to avoid merging
      default = if config.js0ny.desktop.display == "none" then lib.mkForce [ "none" ] else [ ];
      description = ''
        The window manager(s) or desktop environment(s) to use, the first one will be the primary session.
      '';
    };
  };
}

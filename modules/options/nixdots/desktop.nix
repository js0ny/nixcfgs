{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.nixdots.desktop = {
    enable = lib.mkEnableOption "Whether to enable desktop environment modules. This is a global toggle that can be overridden by specific desktop manager modules if needed.";
    dm = lib.mkOption {
      type = lib.types.enum [
        "ly"
        "gdm"
        "sddm"
        "tuigreet"
        "cosmic-greeter"
        "none"
      ];
      default = if config.nixdots.linux.display == "none" then "none" else "gdm";
      description = ''
        The desktop manager to use. Options include:
        - 'ly': A lightweight TUI-based display manager.
        - 'gdm': GNOME Display Manager, suitable for GNOME desktops.
        - 'sddm': Simple Desktop Display Manager, often used with KDE Plasma.
        - 'tuigreet': A modern TUI greeter with theming support.
        - 'cosmic-greeter': The display manager used by Pop!_OS's Cosmic desktop.
        - 'none': Disable the display manager, useful for headless setups or when using a custom DM.
      '';
    };
    de = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "niri"
          "hyprland"
          "sway"
          "kde"
          "gnome"
          "cosmic"
          "none"
        ]
      );
      default = if config.nixdots.linux.display == "none" then [ "none" ] else [ "niri" ];
      description = ''
        The window manager(s) or desktop environment(s) to use.
      '';
    };
    wmShell = lib.mkOption {
      type = lib.types.enum [
        "vanilla"
        "noctalia"
      ];
      default = "vanilla";
      description = ''
        The shell interface that accopanied with a window manager (like niri)
      '';
    };
    niri = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.niri;
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
    };
  };
}

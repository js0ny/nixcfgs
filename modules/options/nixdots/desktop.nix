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
        "cosmic-greeter"
        "plasma-login-manager"
        "dms-greeter"
        "none"
      ];
      default = if config.nixdots.linux.display == "none" then "none" else "gdm";
      description = "The desktop manager to use.";
    };
    autoLogin = lib.mkEnableOption "Whether to login automatically";
    session = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "niri"
          "hyprland"
          "sway"
          "kde"
          "gnome"
          "cosmic"
          "mangowc"
          "none"
        ]
      );
      default = if config.nixdots.linux.display == "none" then [ "none" ] else [ "niri" ];
      description = ''
        The window manager(s) or desktop environment(s) to use, the first one will be the primary session.
      '';
    };
    wm = {
      shell = lib.mkOption {
        type = lib.types.enum [
          "vanilla"
          "noctalia"
          "dank-material-shell"
        ];
        default = "dank-material-shell";
        description = ''
          The shell interface that accopanied with a window manager (like niri)
        '';
      };
      clipboard = lib.mkOption {
        type = lib.types.enum [
          "cliphist"
          "vicinae"
        ];
        default = "cliphist";
        description = ''
          The clipboard history provider that accopanied with a window manager (like niri)
        '';
      };
    };
    hyprland = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.hyprland;
      };
      portalPackage = lib.mkOption {
        type = lib.types.package;
        default = pkgs.xdg-desktop-portal-hyprland;
      };
    };
  };
}

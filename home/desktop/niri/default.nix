{
  pkgs,
  config,
  lib,
  ...
}:
let
  xdg-config = config.xdg.configHome;
in
{
  imports = [
    ../wm-components
  ];

  wayland.windowManager.niri = {
    enable = true;
    validation.enable = true;
    settings = {
      spawn-sh-at-startup = [
        "systemctl --user start waylandwm-session.target"
      ];
    };
    extraConfig = ''
      include "${./base.kdl}"
      ${import ./keymaps.nix { inherit pkgs lib config; }}
      ${import ./interpolates.nix { inherit config; }}
      include "${./window-rules.kdl}"
      include "${xdg-config}/niri/local_test.kdl"

      debug {
          ignore-drm-device "/dev/dri/renderD128"
      }

    '';
  };
  # layout {
  #   focus-ring {
  #     width 0
  #   }
  # }
  #

  systemd.user.tmpfiles.rules = [
    "f ${xdg-config}/niri/local_test.kdl 0644 ${config.home.username} users -"
  ];
}

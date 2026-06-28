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
    ../wm-components/module.nix
  ];

  wayland.windowManager.niri = {
    enable = true;
    validation.enable = true;
    settings = {
      spawn-sh-at-startup = [
        "systemctl --user start waylandwm-session.target"
      ];
      debug._children = [
        {
          ignore-drm-device = "/dev/dri/renderD128";
        }
      ];
    };
    extraConfig = ''
      include "${./base.kdl}"
      ${import ./keymaps.nix { inherit pkgs lib config; }}
      ${import ./interpolates.nix { inherit config; }}
      include "${./window-rules.kdl}"
      include "${xdg-config}/niri/local_test.kdl"
    '';
  };

  systemd.user.tmpfiles.rules = [
    "f ${xdg-config}/niri/local_test.kdl 0644 ${config.home.username} users -"
  ];
}

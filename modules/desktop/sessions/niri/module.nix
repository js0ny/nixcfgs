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
  wayland.windowManager.niri = {
    enable = true;
    checkConfig = true;
    systemd.enable = true;
    settings = {
      spawn-sh-at-startup = [
        "systemctl --user start wm-init.target"
      ];
      debug._children = [
        {
          ignore-drm-device = "/dev/dri/renderD128";
          honor-xdg-activation-with-invalid-serial = true;
        }
      ];
    };
    extraConfig = ''
      include "${./base.kdl}"
      ${import ./keymaps.nix { inherit pkgs lib config; }}
      ${import ./interpolates.nix { inherit config; }}
      include "${./window-rules.kdl}"
    '';
  };

  systemd.user.tmpfiles.rules = [
    "f ${xdg-config}/niri/local_test.kdl 0644 ${config.home.username} users -"
  ];
}

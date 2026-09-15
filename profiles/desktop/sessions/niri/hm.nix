{
  pkgs,
  config,
  lib,
  ...
}:
let
  xdg-config = config.xdg.configHome;
  customDirs = config.home.customDirs;
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
      screenshot-path = "${customDirs.screenshots}/Screenshot from %Y-%m-%d %H-%M-%S.png";
    };
    extraConfig = ''
      include "${./base.kdl}"
      ${import ./keymaps.nix { inherit pkgs lib config; }}
      include "${./window-rules.kdl}"
    '';
  };

  systemd.user.tmpfiles.rules = [
    "f ${xdg-config}/niri/local_test.kdl 0644 ${config.home.username} users -"
  ];
}

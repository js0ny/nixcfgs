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
      debug.ignore-drm-device = "/dev/dri/renderD128";
      screenshot-path = "${customDirs.screenshots}/Screenshot from %Y-%m-%d %H-%M-%S.png";
    };
    extraConfig = ''
      include "${./base.kdl}"
      ${import ./keymaps.nix { inherit pkgs lib config; }}
      include "${./window-rules.kdl}"
      // Generated at runtime by Noctalia when it applies the niri theme template; upstream appends
      // this include to config.kdl, which is read-only under home-manager.
      include optional=true "noctalia.kdl"
      // Local overrides written outside Nix; optional so it also validates in the build sandbox
      // and on a fresh system where tmpfiles has not created it yet.
      include optional=true "local_test.kdl"
    '';
  };

  systemd.user.tmpfiles.rules = [
    "f ${xdg-config}/niri/local_test.kdl 0644 ${config.home.username} users -"
  ];
}

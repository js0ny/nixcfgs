{
  pkgs,
  lib,
  config,
  ...
}:
{
  # https://wiki.archlinux.org/title/Zoom_Meetings#Running_on_Wayland_without_Xwayland
  mergetools.zoomusConfig = {
    target = "${config.home.homeDirectory}/.var/app/us.zoom.Zoom/config/zoomus.conf";
    format = "ini";
    settings = {
      General = {
        xwayland = false;
      };
    };
  };

  home.packages = with pkgs; [
    nixpaks.zoom-us
  ];
}

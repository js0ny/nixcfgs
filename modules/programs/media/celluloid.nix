{
  pkgs,
  config,
  ...
}:
{
  # MPV GTK4 frontend
  home.packages = [ pkgs.celluloid ];
  dconf.settings = {
    "io/github/celluloid-player/celluloid" = {
      mpv-config-enable = true;
      mpv-input-config-enable = true;
      mpv-config-file = "file://${config.xdg.configHome}/mpv/mpv.conf";
      mpv-input-config-file = "file://${config.xdg.configHome}/mpv/input.conf";
    };
  };
}

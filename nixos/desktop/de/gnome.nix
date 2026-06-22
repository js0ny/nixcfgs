{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.de;
in
lib.mkIf (config.nixdots.desktop.enable && builtins.elem "gnome" cfg) {
  services.desktopManager.gnome = {
    enable = true;
    sessionPath = with pkgs; [
      gtop
      gnome-menus
      gobject-introspection
      # Copyous
      libgda6
      gsound
    ];
  };
  environment.systemPackages = with pkgs; [
    gnome-menus
    gobject-introspection
  ];
  environment.gnome.excludePackages = with pkgs; [
    # keep-sorted start
    evince # Document Viewer (Legacy)
    totem # GNOME Videos (legacy)
    papers # Document Viewer
    gnome-tour
    baobab # Disk Usage Analyzer, use dust instead
    epiphany # GNOME Web
    gnome-system-monitor # use mission-center
    gnome-terminal
    gnome-console
    showtime # Media player
    gnome-music
    gnome-connections
    gnome-font-viewer
    gnome-maps
    gnome-text-editor
    simple-scan # Document Scanner
    snapshot # Camera
    gnome-characters
    decibels # Audio Player
    yelp # Help
    # keep-sorted end
  ];
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };
  services.gnome.sushi.enable = true;
  programs.gnome-terminal.enable = false;
}

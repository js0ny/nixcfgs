{
  pkgs,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.session;
  enableSession = sessionName: builtins.elem sessionName cfg;
in
{
  xdg.portal.enable = true;
  programs = {
    niri.enable = enableSession "niri";
    sway.enable = enableSession "sway";
    hyprland.enable = enableSession "hyprland";
    uwsm.enable = enableSession "hyprland";
    mangowc.enable = enableSession "mangowc";

    sway = {
      xwayland.enable = true;
      extraOptions = [ "--unsupported-gpu" ];
    };
    hyprland = {
      withUWSM = true;
      xwayland.enable = true;
      systemd.setPath.enable = true;
    };
  };

  services.desktopManager = {
    cosmic.enable = enableSession "cosmic";
    gnome.enable = enableSession "gnome";
    plasma6.enable = enableSession "kde";
  };

  services.desktopManager.gnome = {
    sessionPath = with pkgs; [
      gtop
      gnome-menus
      gobject-introspection
      # Copyous
      libgda6
      gsound
    ];
  };
  environment = {
    gnome.excludePackages = with pkgs; [
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
    plasma6.excludePackages = with pkgs.kdePackages; [
      kate # kate and kwrite
      # disable kwallet, use ../gnome-keyring.nix
      kwallet # provides helper service
      kwallet-pam # provides helper service
      kwalletmanager # provides KCMs and stuff
      qrca
      kde-gtk-config # DISABLE settings sync to GTK applications
    ];
    cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-term
      cosmic-wallpapers
      cosmic-reader
      cosmic-player
    ];
  };

  # programs.nautilus-open-any-terminal = {
  #   enable = true;
  #   terminal = "kitty";
  # };
  # services.gnome.sushi.enable = true;
}

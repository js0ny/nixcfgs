{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # ../../walker.nix
    ./waybar
    ./awww.nix
    ./kanshi.nix
    # ./swaylock.nix
    ./polkit.nix
    ./hyprlock.nix
    ./swayidle.nix
    ./sunsetr.nix
    ./systemd.nix
    ./dunst.nix
    ./volume-notify.nix
  ];
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    localPkgs.power-profiles-next
    trash-cli
  ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      niri = {
        default = [
          "wlr"
          "gnome"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.FileChooser" = [
          "gnome"
          "gtk"
        ];
      };
      kde = {
        default = [
          "kde"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "kde" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "kde" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "kde" ];
        "org.freedesktop.impl.portal.FileChooser" = [
          "kde"
          "gtk"
        ];
      };
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
      sway = {
        default = [
          "wlr"
          "gtk"
        ];
      };
      gnome = {
        default = [
          "gnome"
          "gtk"
        ];
      };
    };
  };
  # TODO: Allow launching components from all wayland-wm sessions
  # services.cliphist.enable = true; # use elephant + walker
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  services.blueman-applet.systemdTargets = [ "niri.service" ];
  systemd.user.services.hypridle.Install.WantedBy = [ "niri.service" ];
  systemd.user.services.network-manager-applet.Install.WantedBy = lib.mkForce [ "niri.service" ];
  programs.wleave.enable = true;
  # https://wiki.archlinux.org/title/Visual_Studio_Code
  home.sessionVariables = {
    ELECTRON_TRASH = "trash-cli";
  };
}

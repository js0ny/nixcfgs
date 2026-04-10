{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../walker.nix
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
    swayidle # Screensaver
    cliphist # Clipboard daemon
    # swayidleWrapper
    brightnessctl
    playerctl
    localPkgs.power-profiles-next
  ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
  # TODO: Allow launching components from all wayland-wm sessions
  # services.cliphist.enable = true; # use elephant + walker
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  services.blueman-applet.systemdTargets = [ "niri.service" ];
  systemd.user.services.network-manager-applet.Install.WantedBy = lib.mkForce [ "niri.service" ];
  programs.wleave.enable = true;
}

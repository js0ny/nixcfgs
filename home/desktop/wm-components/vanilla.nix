{
  pkgs,
  lib,
  config,
  ...
}:
let
  vicinae = config.nixdefs.consts.vicinae;
in
{
  imports = [
    # ../../walker.nix
    ./waybar.nix
    ./kanshi.nix
    # ./swaylock.nix
    ./polkit.nix
    ./hyprlock.nix
    ./swayidle.nix
    ./sunsetr.nix
    ./systemd.nix
    ./volume-notify.nix
    ./.
  ];
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    localPkgs.power-profiles-next
    trash-cli
  ];
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
    XAUTHORITY = "$XDG_RUNTIME_DIR/.XAuthority";
  };
  services.awww = {
    enable = true;
  };
  systemd.user.services.awww.Install.WantedBy = [ "niri.service" ];
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        indicate_hidden = "yes";
        dmenu = lib.concatStringsSep " " vicinae.dmenu;
        browser = lib.getExe' pkgs.xdg-utils "xdg-open";
      };
    };
  };
  systemd.user.services.dunst = {
    Install.WantedBy = lib.mkForce [ "niri.service" ];
  };
}

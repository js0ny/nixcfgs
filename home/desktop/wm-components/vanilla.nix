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
    # keep-sorted start
    ./.
    ./awww.nix
    ./hyprlock.nix
    ./kanshi.nix
    # ./swaylock.nix
    ./polkit.nix
    ./sunsetr.nix
    ./swayidle.nix
    ./systemd.nix
    ./volume-notify.nix
    # ../../walker.nix
    ./waybar.nix
    # keep-sorted end
  ];
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    localPkgs.power-profiles-next
    trash-cli
  ];
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  services.blueman-applet.systemdTargets = [ "waylandwm-session.target" ];
  systemd.user.services.hypridle = {
    Unit = {
      PartOf = [ "waylandwm-session.target" ];
      After = [ "waylandwm-session.target" ];
    };
    Install.WantedBy = [ "waylandwm-session.target" ];
  };
  systemd.user.services.network-manager-applet = {
    Unit = {
      PartOf = [ "waylandwm-session.target" ];
      After = [ "waylandwm-session.target" ];
    };
    Install.WantedBy = lib.mkForce [ "waylandwm-session.target" ];
  };
  programs.wleave.enable = true;
  # https://wiki.archlinux.org/title/Visual_Studio_Code
  home.sessionVariables = {
    ELECTRON_TRASH = "trash-cli";
    XAUTHORITY = "$XDG_RUNTIME_DIR/.XAuthority";
  };
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
    Unit = {
      PartOf = [ "waylandwm-session.target" ];
      After = [ "waylandwm-session.target" ];
    };
    Install.WantedBy = lib.mkForce [ "waylandwm-session.target" ];
  };
}

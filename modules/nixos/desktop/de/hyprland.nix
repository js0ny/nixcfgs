{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.nixdots.desktop.de;
  # hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  # hyprlandSession = pkgs.writeTextFile {
  #   name = "hyprland-uwsm";
  #   text = ''
  #     [Desktop Entry]
  #     Name=Hyprland (UWSM)
  #     Comment=Hyprland compositor managed by UWSM
  #     Exec=${lib.getExe config.programs.uwsm.package} start -F -D Hyprland -e -N Hyprland -C "Hyprland compositor managed by UWSM" -- ${lib.getExe' hyprland.hyprland "start-hyprland"}
  #     Type=Application
  #   '';
  #   destination = "/share/wayland-sessions/hyprland-uwsm.desktop";
  #   derivationArgs.passthru.providedSessions = [ "hyprland-uwsm" ];
  # };
in
lib.mkIf (config.nixdots.desktop.enable && builtins.elem "hyprland" cfg) {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.uwsm = {
    enable = true;
  };

  # environment.systemPackages = with pkgs; [
  #   hyprlandSession
  #   hyprland.hyprland
  # ];

  xdg.portal.enable = true;

  # services.displayManager.sessionPackages = [ hyprlandSession ];
}

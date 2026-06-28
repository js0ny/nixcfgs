_: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    systemd.setPath.enable = true;
  };
  programs.uwsm.enable = true;
}

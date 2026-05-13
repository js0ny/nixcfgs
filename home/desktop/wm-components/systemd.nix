{
  systemd.user.targets.waylandwm-session = {
    Unit = {
      Description = "Window Manager session, used to run services tied to the WM lifecycle";
      Documentation = [ "man:systemd.special(7)" ];
      PartOf = [ "graphical-session.target" ];
    };
  };
}

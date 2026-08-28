{
  systemd.user.targets = {
    "wm-init" = {
      partOf = [ "graphical-session.target" ];
      description = "Window Manager session, used to run services tied to the WM lifecycle";
      documentation = [ "man:systemd.special(7)" ];
    };
    "shell-init" = {
      partOf = [ "graphical-session.target" ];
      description = "Window Manager session, used to run services tied to the WM lifecycle";
      documentation = [ "man:systemd.special(7)" ];
    };
    "de-init" = {
      partOf = [ "graphical-session.target" ];
      description = "Window Manager session, used to run services tied to the WM lifecycle";
      documentation = [ "man:systemd.special(7)" ];
    };
  };
}

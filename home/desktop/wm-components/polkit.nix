{ pkgs, ... }:
{
  systemd.user.services.polkit-agent = {
    Unit = {
      Description = "Polkit agent";
      PartOf = [ "waylandwm-session.target" ];
      After = [ "waylandwm-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Environment = [
        "QML2_IMPORT_PATH=${pkgs.kdePackages.qqc2-desktop-style}/lib/qt-6/qml"
        "QT_QUICK_CONTROLS_STYLE=org.kde.desktop"
        "QT_STYLE_OVERRIDE="
      ];
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };

    Install = {
      WantedBy = [ "waylandwm-session.target" ];
    };
  };
}

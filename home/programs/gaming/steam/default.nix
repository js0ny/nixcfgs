# https://github.com/different-name/steam-config-nix
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Steam Achievement Manager
    samira
    steamcmd # from overlays
    # Steam Adwaita Theme
    adwsteamgtk
    # All-in-one Steam and Proton Tools
    steamtinkerlaunch
  ];
  nixdots.persist.home = {
    directories = [
      ".local/share/Steam"
      ".steam"
    ];
  };
}

{ pkgs, config, ... }:
let
  prefix = "${config.xdg.dataHome}/wineprefixes/default";
in
{
  home.packages = with pkgs; [
    protontricks
    # Use Wayland-native wine for better performance and support
    wineWow64Packages.waylandFull
    winetricks
  ];
  nixdots.persist.nosnap.home = {
    directories = [
      ".local/share/wineprefixes"
      ".local/share/wine-apps"
    ];
  };
  home.sessionVariables = {
    WINEPREFIX = prefix;
  };
}

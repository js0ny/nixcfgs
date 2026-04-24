{ pkgs, ... }:
{
  home.packages = with pkgs; [
    protontricks
    # Use Wayland-native wine for better performance and support
    wineWow64Packages.waylandFull
    winetricks
  ];
  dconf.settings = {
    "com/usebottles/bottles" = {
      steam-proton-support = true;
    };
  };
}

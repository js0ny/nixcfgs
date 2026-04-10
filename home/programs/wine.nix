{ pkgs, ... }:
{
  home.packages = with pkgs; [
    protontricks
    bottles
    # Use Wayland-native wine for better performance and support
    wineWow64Packages.waylandFull
    winetricks
  ];
  dconf.settings = {
    "com/usebottles/bottles" = {
      update-date = true;
      steam-proton-support = true;
      startup-view = "page_library";
    };
  };
}

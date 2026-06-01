# https://github.com/different-name/steam-config-nix
{ pkgs, inputs, ... }:
let
  vicinae-extensions = inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.sessionVariables = {
    SDL_JOYSTICK_HIDAPI = "0";
  };
  home.packages = with pkgs; [
    # Steam Achievement Manager
    samira
    steamcmd # from overlays
    # Steam Adwaita Theme
    adwsteamgtk
    # All-in-one Steam and Proton Tools
    steamtinkerlaunch
  ];
  nixdots.persist.nosnap.home = {
    directories = [
      ".local/share/Steam"
      ".steam"
    ];
  };
  programs.steam.config = {
    enable = true;
    closeSteam = true;
  };
  # Lost & Found
  xdg.desktopEntries = {
    samira = {
      name = "Samira";
      icon = "samira";
      comment = "Steam achievement manager for Linux";
      exec = "samira";
      terminal = false;
      categories = [
        "Game"
      ];
      settings = {
        StartupWMClass = "samira";
      };
    };
  };
  programs.vicinae.extensions = with vicinae-extensions; [ protondb-search ];
}

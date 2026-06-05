{
  pkgs,
  lib,
  config,
  ...
}:
let
  isHeadless = config.nixdots.linux.display == "none";
  customFastfetch = pkgs.fastfetch.override {
    x11Support = false;
    sqliteSupport = true;

    audioSupport = !isHeadless;
    brightnessSupport = !isHeadless;
    dbusSupport = !isHeadless;
    terminalSupport = !isHeadless;
    enlightenmentSupport = false;
    gnomeSupport = false;
    xfceSupport = false;
    openclSupport = !isHeadless;
    openglSupport = !isHeadless;
    vulkanSupport = !isHeadless;
    waylandSupport = !isHeadless;
    imageSupport = !isHeadless;
  };
in
{
  programs.fastfetch = {
    enable = true;
    package = customFastfetch;
    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          right = 1;
        };
      };
      display = {
        size = {
          binaryPrefix = "si";
        };
        color = "blue";
        separator = "  ";
      };
      modules = [
        {
          type = "datetime";
          key = "Date";
          format = "{1}-{3}-{11}";
        }
        {
          type = "datetime";
          key = "Time";
          format = "{14}:{17}:{20}";
        }
        "break"
        "player"
        "media"
      ];
    };
  };
}

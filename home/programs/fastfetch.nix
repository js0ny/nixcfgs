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
  };
}

{
  pkgs,
  config,
  ...
}:
let
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  programs.firefox.profiles."${p}".containerise = {
    enable = true;
    settings = {
      "Academia" = {
        containerId = 8;
        patterns = [
          "*.office.com"
        ];
      };
      "Chinese" = {
        containerId = 9;
        patterns = [
          "*.zhihu.com"
          "*.bilibili.com"
        ];
      };
    };
  };
}

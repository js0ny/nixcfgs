{ lib, ... }:
{
  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      keybinds = {
        next = [
          "Down"
          "ctrl j"
          "ctrl n"
        ];
        previous = [
          "Up"
          "ctrl k"
          "ctrl p"
        ];
      };
      providers = {
        default = [
          "websearch"
          "desktopapplications"
          "calc"
        ];
        prefixes = [
          {
            provider = "websearch";
            prefix = "+";
          }
          {
            provider = "providerlist";
            prefix = "_";
          }
        ];
      };
    };
  };
  xdg.configFile."elephant/websearch.toml".text = lib.mkDefault ''
    [[entries]]
    default = true
    name = "DuckDuckGo"
    url = "https://www.duckduckgo.com/search?q=%TERM%"

    [[entries]]
    default = false
    name = "Google"
    url = "https://www.google.com/search?q=%TERM%"

  '';
}

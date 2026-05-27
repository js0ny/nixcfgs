{ config, ... }:
{
  programs.qutebrowser = {
    # BUG presents with nvidia gpu on qtwebengine
    enable = (config.nixdots.linux.gpu != "nvidia" && config.nixdots.linux.display != "none");
    searchEngines = {
      g = "https://www.google.com/search?hl=en&q={}";
    };
  };
  xdg.dataFile."qutebrowser/greasemonkey" = {
    recursive = true;
    source = ./greasemonkey;
  };
}

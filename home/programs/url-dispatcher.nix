{ ... }:
{

  programs.urlDispatcher = {
    enable = true;

    defaultBrowser = "firefox";
    incognitoBrowser = "chromium --incognito";

    allowList = [
      "github\\.com"
      "ycombinator\\.com"
      "reddit\\.com"
      "localhost"
      "127\\.0\\.0\\.1"
      "zhihu\\.com"
    ];

    denyList = [
      "twitter\\.com"
      "x\\.com"
      "weibo\\.com"
      "douban\\.com"
    ];

    defaultBehaviour = "allow";
  };
}

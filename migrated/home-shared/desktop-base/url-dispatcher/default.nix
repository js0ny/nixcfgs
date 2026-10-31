{
  lib,
  config,
  ...
}:
{
  imports = [ ./option.nix ];

  programs.urlDispatcher = {
    enable = true;

    defaultBrowser = [ (lib.getExe config.programs.firefox.package) ];
    incognitoBrowser = [
      (lib.getExe config.programs.chromium.finalPackage)
      "--incognito"
    ];

    trusted = [
      "github\\.com"
      "ycombinator\\.com"
      "reddit\\.com"
      "localhost"
      "127\\.0\\.0\\.1"
      "zhihu\\.com"
    ];

    untrusted = [
      "twitter\\.com"
      "x\\.com"
      "weibo\\.com"
      "douban\\.com"
    ]
    ++ config.secrets.plain.urlDispatcher.denyList;

    echoEnv = [
      "SSH_CLIENT"
      "SSH_TTY"
    ];

    defaultBehaviour = "allow";
  };
}

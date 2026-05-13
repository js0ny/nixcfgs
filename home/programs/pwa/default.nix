{
  config,
  pkgs,
  lib,
  ...
}:
let
  pwaBrowser =
    if config.programs.chromium.enable then config.programs.chromium.package else pkgs.chromium;
  pwaExe = lib.getExe pwaBrowser;
  pwaBuilder =
    name: url:
    {
      icon ? "web-app-icon",
      genericName ? "Web Application",
    }:
    {
      name = name;
      genericName = genericName;
      exec = "${pwaExe} --app=${url}";
      terminal = false;
      icon = icon;

      settings = {
        StartupWMClass = "pwa-${name}";
      };
    };
in
{
  xdg.desktopEntries = {
    chatgpt = pwaBuilder "ChatGPT" "https://chatgpt.com" { icon = ./openai.webp; };
    gemini = pwaBuilder "Gemini" "https://gemini.google.com" { };
    notebooklm = pwaBuilder "NotebookLM" "https://notebooklm.google.com" { };
    tradingview = pwaBuilder "TradingView" "https://www.tradingview.com" { };
  };
}

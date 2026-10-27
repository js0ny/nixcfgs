{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  programs.codex.settings.desktop = {
    followUpQueueMode = "queue";
    localeOverride = "zh-CN";
    show-context-window-usage = true;
    notifications-turn-mode = "unfocused";
    appearanceLightCodeThemeId = "catppuccin";
    appearanceDarkCodeThemeId = "catppuccin";
    usePointerCursors = true;
    appearanceDiffMarkerStyle = "color";
    browser-show-full-url = true;
    keepRemoteControlAwakeWhilePluggedIn = false;
    open-in-target-preferences.global = "ghostty";
    # Catppuccin
    appearanceLightChromeTheme = {
      accent = "#8839ef";
      accentSource = "custom";
      contrast = 45;
      ink = "#4c4f69";
      opaqueWindows = false;
      surface = "#eff1f5";
      semanticColors = {
        diffAdded = "#40a02b";
        diffRemoved = "#d20f39";
        skill = "#8839ef";
      };
    };
    appearanceDarkChromeTheme = {
      accent = "#cba6f7";
      accentSource = "custom";
      contrast = 60;
      ink = "#cdd6f4";
      opaqueWindows = false;
      surface = "#1e1e2e";
      semanticColors = {
        diffAdded = "#a6e3a1";
        diffRemoved = "#f38ba8";
        skill = "#cba6f7";
      };
    };
  };
  home.packages = lib.optionals (osConfig.hardware.graphics.enable) [ pkgs.llm-agents.chatgpt ];
}

{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  programs.codex.settings.desktop = {
    followUpQueueMode = "queue";

    # UI
    show-context-window-usage = true;
    localeOverride = "zh-CN";

    # Git
    git-branch-prefix = "agent/";
    git-pull-request-merge-method = "merge";
    git-create-pull-request-as-draft = true;
    reviewDelivery = "detached";

    # Worktree
    worktree-upstream-refresh-mode = "best-effort";
    worktree-auto-cleanup-enabled = false;
    worktree-confirm-before-delete = true;

    # Desktop Integration
    notifications-turn-mode = "unfocused";
    open-in-target-preferences.global = "ghostty";
    usePointerCursors = true;
    browser-show-full-url = true;
    keepRemoteControlAwakeWhilePluggedIn = false;

    # Theme
    appearanceTheme = "system";
    appearanceDiffMarkerStyle = "color";
    appearanceLightCodeThemeId = "catppuccin";
    appearanceLightChromeTheme = {
      accent = "#8839ef";
      accentSource = "custom";
      contrast = 45;
      ink = "#4c4f69";
      opaqueWindows = false;
      semanticColors = {
        diffAdded = "#40a02b";
        diffRemoved = "#d20f39";
        skill = "#8839ef";
      };
      surface = "#eff1f5";
    };
    appearanceDarkCodeThemeId = "catppuccin";
    appearanceDarkChromeTheme = {
      accent = "#cba6f7";
      contrast = 60;
      fonts = {
        code = ''"JetBrainsMono Nerd Font"'';
      };
      ink = "#cdd6f4";
      opaqueWindows = true;
      semanticColors = {
        diffAdded = "#a6e3a1";
        diffRemoved = "#f38ba8";
        skill = "#cba6f7";
      };
      surface = "#1e1e2e";
    };
  };
  home.packages = lib.optionals (osConfig.hardware.graphics.enable) [ pkgs.llm-agents.chatgpt ];
}

{ ... }:
{
  programs.obsidian.defaultSettings.communityPlugins."vim-im-select" = {
    enable = true;
    settings = {
      defaultIM = "keyboard-us";
      obtainCmd = "fcitx5-remote -n";
      switchCmd = "fcitx5-remote -s {im}";
      windowsDefaultIM = "";
      windowsObtainCmd = "";
      windowsSwitchCmd = "";
    };
  };
}

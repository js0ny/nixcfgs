{ config, ... }:
let
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  programs.firefox.profiles."${p}".cookie-autodelete = {
    enable = true;
    active = true;
    cleanLocalStorage = true;
    enableContainers = true;
    showNotifications = false;
    lists = {
      default.allowList = [
        # keep-sorted start
        "*.apple.com"
        "*.chatgpt.com"
        "*.codeberg.org"
        "*.github.com"
        "*.hetzner.com"
        "*.js0ny.net"
        "*.proton.me"
        "*.tailscale.com"
        "platform.deepseek.com"
        # keep-sorted end
      ];

      # Google
      "firefox-container-6".allowList = [
        "*.google.com"
        "*.youtube.com"
      ];
      # Academia
      "firefox-container-8".allowList = [
        "*.microsoftonline.com"
      ];
      # Chinese
      "firefox-container-9".allowList = [
        "*.bilibili.com"
        "*.baidu.com"
        "*.zhihu.com"
        "*.apple.com.cn"
      ];
    };
  };
}

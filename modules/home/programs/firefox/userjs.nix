{
  lib,
  pkgs,
  config,
  ...
}:
let
  p = config.nixdots.programs.firefox.defaultProfile;
  baseprefs = import ../../../common/firefox-baseprefs.nix;
  selfhosted = config.nixdefs.selfhosted;
  open-webui = selfhosted.open-webui;
in
{
  programs.firefox = {
    profiles."${p}" = {
      settings = {
        "signon.rememberSignons" = false;
        "browser.urlbar.suggest.history" = true;

        "browser.ml.enabled" = true;
        "browser.ml.chat.hideLocalhost" = false;

        "browser.toolbars.bookmarks.visibility" = "never";
        "extensions.update.enabled" = true;
        "sidebar.expandOnHover" = true;
        "sidebar.visibility" = "expand-on-hover";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "toolkit.tabbox.switchByScrolling" = true;
        "browser.uidensity" = 1;
        ### Disable Menu when pressing <Alt>
        "ui.key.menuAccessKey" = -1;
        "ui.key.menuAccessKeyFocuses" = false;
        # Disable GTK native emoji picker (Ctrl+.)
        "widget.gtk.native-emoji-dialog" = lib.mkDefault false;
        ### Disable Translations
        "browser.translations.enable" = lib.mkDefault false;
        "browser.translations.automaticallyPopup" = lib.mkDefault false;
        "browser.translations.select.enable" = lib.mkDefault false;
        ### CJK IME Optimisation
        "browser.urlbar.keepPanelOpenDuringImeComposition" = true;
        "browser.tabs.closeTabByDblclick" = true;
        # Disable Ctrl-Q / Ctrl-Shift-W
        "browser.quitShortcut.disabled" = if pkgs.stdenv.isDarwin then false else true;
        ### Session
        # * 0: Blank Page
        # * 1: Home Page
        # * 2: Last Visited Pages
        # * 3: Restore Previous Session
        "browser.startup.page" = 3;
        "browser.sessionstore.resume_from_crash" = true;
        ### Sync
        "services.sync.declinedEngines" = "creditcards,passwords,addresses,prefs,addons";
        "services.sync.engine.addons" = false;
        "services.sync.engine.addresses" = false;
        "services.sync.engine.bookmarks" = true;
        "services.sync.engine.creditcards" = false;
        "services.sync.engine.history" = true;
        "services.sync.engine.passwords" = false;
        "services.sync.engine.prefs" = false;
        "services.sync.engine.prefs.modified" = false;
        "services.sync.engine.tabs" = true;
        "services.sync.engins.tabs.filteredSchemes" = "about|resource|chrome|file|blob|moz-extension|data";

        # * Middle Key Behaivour
        # Autoscroll on middle-click
        "general.autoScroll" = true;
        # Paste on middle-click
        "middlemouse.paste" = true;

        # 扩展运行权限与相应的安全防御
        # ==============================================================================

        # * 解除官方域名扩展运行限制
        # 默认情况下，Firefox 禁止任何扩展在 addons.mozilla.org 等官方域名上运行。
        # 清空此域名列表，以允许 Surfingkeys 等扩展在这些页面正常工作。
        "extensions.webextensions.restrictedDomains" = "";

        # * 禁用 mozAddonManager 特权 API
        # 解除上述限制后，恶意扩展可能通过向 AMO 注入脚本来滥用 AMO 独有的
        # mozAddonManager API，从而实现“静默安装恶意插件”等高危越权操作。开启此项可在
        # 网页前端彻底封堵该 API，完美弥补权限开放带来的提权漏洞。
        # 防止网站通过读取已安装的扩展列表来生成精确的浏览器指纹。
        # 注：AMO 网站将无法获取当前扩展安装状态，已安装的扩展也会显示“添加到 Firefox”。
        "privacy.resistFingerprinting.block_mozAddonManager" = true;

        # New Features
        # 147: Keep playing videos in Picture-in-Picture when switching tabs
        "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = false;
      }
      // (lib.optionalAttrs (pkgs.stdenv.isDarwin) baseprefs)
      // (lib.optionalAttrs (open-webui.enable && open-webui.integrations.firefox) {
        browser.ml.chat.provider = open-webui.url;
      });
    };
  };
}

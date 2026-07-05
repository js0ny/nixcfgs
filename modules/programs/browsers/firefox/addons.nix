{
  pkgs,
  config,
  ...
}:
let
  addons = pkgs.firefox-addons;
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  catppuccin.firefox.enable = true;
  programs.firefox.profiles."${p}" = {
    extensionStorage."gemini-voyager@nagi-ovo".settings = {
      gvChangelogNotifyMode = "badge";
    };
    extensions.force = true;
    extensions.packages = with addons; [
      # Keybindings & Gestures & User Scripts
      shortkeys
      surfingkeys_ff
      violentmonkey
      sidebery

      # Theming
      material-icons-for-github
      firefox-color

      # Browsing Enhancement
      darkreader
      bionic-reader
      ublock-origin
      refined-github-
      global-speed
      buster-captcha-solver

      # Cookies
      cookie-quick-manager
      cookie-autodelete
      istilldontcareaboutcookies

      # Privacy
      google-container
      facebook-container
      dont-track-me-google1

      ### Site Specific
      # Steam
      steam-database
      protondb-for-steam
      # YouTube
      return-youtube-dislikes
      sponsorblock
      # Bilibili
      bilisponsorblock

      # Misc
      rsshub-radar
      proton-pass
      proton-vpn-firefox-extension
      styl-us
      kiss-translator
      auto-tab-discard
      gesturefy
      karakeep
      leechblock-ng
      copy-latex

      # Disabled
      # view-page-archive # Web Archives
      # single-file
      # downthemall

      # Install globally by policies: see nixosModules.firefox
      # clearurls
      # multi-account-container
    ];
    containerise = {
      enable = true;
      settings = {
        "Academia" = {
          containerId = 8;
          patterns = [
            "*.office.com"
          ];
        };
        "Chinese" = {
          containerId = 9;
          patterns = [
            "*.zhihu.com"
            "*.bilibili.com"
          ];
        };
      };
    };
    surfingkeys = {
      enable = true;
      showAdvanced = true;
      blocklist = [
        "https://svelte.dev"
        "https://docs-editor.proton.me"
        "https://www.shoutoutuk.org"
        "https://www.notion.so"
        "https://console.hetzner.com"
      ];
      snippets = builtins.readFile ./surfingkeys.js;
    };

  };

}

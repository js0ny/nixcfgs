{
  pkgs,
  config,
  myLib,
  ...
}:
let
  addons = pkgs.firefox-addons;
  nur-addons = pkgs.nur.repos.rycee.firefox-addons;
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  imports = myLib.scanPaths ./.;
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

      # Install globally by policies: see modules/nixos/programs/firefox.nix
      # clearurls
      # multi-account-container
    ];
  };

}

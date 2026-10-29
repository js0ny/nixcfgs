{ pkgs, ... }: {
  programs.firefox.profiles.js0ny.userContent = /* css */ ''
    @import url(content/compact_about_config.css)
  '';
  # xdg.configFile = {
  #   "mozilla/firefox/js0ny/chrome/content".source = pkgs.linkFarm {
  #     "compact_about_config.css" = "${pkgs.js0ny.firefox-csshacks}/compact_about_config.css";
  #   };
  # };
}

{ config, pkgs, ... }:
let
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  programs.firefox.profiles."${p}" = {
    userChrome = builtins.readFile ./userChrome.css;
    userContent = ''
      @import "${pkgs.misc.data.firefox-csshacks}/content/multi_column_addons.css"
      @import "${pkgs.misc.data.firefox-csshacks}/content/compact_about_config.css"
    '';
  };
}

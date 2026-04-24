{ config, pkgs, ... }:
let
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  programs.firefox.profiles."${p}" = {
    userChrome = builtins.readFile ./userChrome.css;
    # FIXME: Find a more elegant way to pass files
    # userContent = ''
    #   @import "${pkgs.localPkgs.firefox-csshacks}/content/multi_column_addons.css"
    #   @import "${pkgs.localPkgs.firefox-csshacks}/content/compact_about_config.css"
    # '';
  };
}

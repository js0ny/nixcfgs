# New in Firefox 147
# about:keyboard
{
  pkgs,
  config,
  ...
}: let
  profileDir =
    if pkgs.stdenv.isDarwin
    then "Library/Application Support/Firefox/Profiles"
    else ".mozilla/firefox";
  p = config.nixdots.programs.firefox.defaultProfile;
in {
  home.file."${profileDir}/${p}/customKeys.json" = {
    text = builtins.toJSON {
      key_privatebrowsing = {
        modifiers = "accel,shift";
        key = "N";
      };
      key_undoCloseWindow = {};
      viewGenaiChatSidebarKb = {};
      key_viewInfo = {};
      key_switchTextDirection = {};
    };
    force = true;
  };
}

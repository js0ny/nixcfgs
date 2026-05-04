{
  config,
  pkgs,
  ...
}:
let
  profile = config.nixdots.user.name;
  nur-addons = pkgs.nur.repos.rycee.firefox-addons;
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  home.packages = with pkgs; [ zotero ];
  home.file = {
    ".zotero/profiles.ini".text = ''
      [General]
      StartWithLastProfile=1
      Version=2

      [Profile0]
      Default=1
      IsRelative=1
      Name=${profile}
      Path=${profile}
    '';
    # Antidots
    ".zotero/${profile}/user.js".text = ''
      user_pref("extensions.zotero.dataDir", "${config.home.homeDirectory}/.local/share/Zotero");
      user_pref("extensions.zotero.export.quickCopy.setting", "bibliography=http://www.zotero.org/styles/ieee");
      user_pref("intl.locale.requested", "${config.nixdots.core.locales.guiLocale}");
    '';
  };
  nixdots.persist.home = {
    directories = [
      ".zotero"
      ".local/share/Zotero"
    ];
  };
  services.xremap.config.keymap = [
    {
      name = "Zotero PDF Navigator";
      application = {
        only = [ "Zotero" ];
      };
      remap = {
        "M-j" = "KEY_PAGEDOWN";
        "M-k" = "KEY_PAGEUP";
      };
    }
  ];
  programs.firefox.profiles."${p}".extensions.packages = [ nur-addons.zotero-connector ];
}

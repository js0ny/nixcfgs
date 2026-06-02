{
  config,
  pkgs,
  ...
}:
let
  dotDir = ".local/share/dot_zotero";
  libraryDir = ".local/share/Zotero";
  profile = config.nixdots.user.name;
  nur-addons = pkgs.nur.repos.rycee.firefox-addons;
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  home.packages =
    if pkgs.stdenv.isLinux then
      [
        (pkgs.nixpaks.zotero.override {
          dotDir = dotDir;
          libraryDir = libraryDir;
        })
      ]
    else
      [ pkgs.zotero ];
  home.file = {
    "${dotDir}/zotero/profiles.ini".text = ''
      [General]
      StartWithLastProfile=1
      Version=2

      [Profile0]
      Default=1
      IsRelative=1
      Name=${profile}
      Path=${profile}
    '';
    "${dotDir}/zotero/${profile}/user.js".text = /* javascript */ ''
      user_pref("extensions.zotero.export.quickCopy.setting", "bibliography=http://www.zotero.org/styles/ieee");
      user_pref("intl.locale.requested", "${config.nixdots.core.locales.guiLocale}");
    '';
  };
  nixdots.persist.nosnap.home = {
    directories = [
      dotDir
      libraryDir
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

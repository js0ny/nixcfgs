{
  pkgs,
  config,
  ...
}: let
  dots = config.nixdots.core.dots;
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  home.packages = with pkgs.kdePackages; [
    dolphin-plugins
    konsole
  ];
  programs.dolphin = {
    enable = true;
    services."move-file" = {
      mimeType = "all/all";
      icon = "mail-move";
      desktopEntryExtra = {
        "X-KDE-Submenu" = "Move file to...";
        "X-KDE-Submenu[CN]" = "将文件移动到";
      };
      actions = {
        to-inbox = {
          name = "Inbox";
          icon = "inbox";
          exec = "mv \"%f\" $HOME/Inbox/";
        };
        to-public = {
          name = "Public";
          icon = "document-share";
          exec = "mv \"%f\" $HOME/Public/";
        };
      };
    };
  };
  xdg.dataFile."kxmlgui5/dolphin/dolphinui.rc".source = mkSymlink "${dots}/users/programs/dolphin/dolphinui.rc";
}

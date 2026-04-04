{pkgs, ...}: {
  home.packages = [pkgs.miniserve];

  programs.dolphin.services.miniserve = {
    mimeType = "inode/directory";
    icon = "network-server";
    desktopEntryExtra = {
      "X-KDE-Priority" = "TopLevel";
      "X-KDE-StartupNotify" = false;
    };
    actions = {
      miniserveDir = {
        name = "Map Directory to Port 8080";
        exec = "xdg-terminal-exec --title=\"miniserve\" miniserve \"%f\" --port 8080";
        extraFields = {
          "Name[CN]" = "将目录映射到网上(8080)";
        };
      };
    };
  };
}

{
  flake.nixosModules.dolphin = { pkgs, ... }: {
    environment.systemPackages = with pkgs.kdePackages; [
      dolphin
      dolphin-plugins
      kio-admin
    ];
    # See: https://github.com/NixOS/nixpkgs/issues/409986
    environment.etc."xdg/menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  };
  flake.homeModules.dolphin =
    {
      pkgs,
      lib,
      config,
      inputs,
      ...
    }:
    let
      dots = config.nixdots.core.dots;
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      imports = [
        ./hm-options.nix
        inputs.plasma-manager.homeModules.plasma-manager
        inputs.self.homeModules.konsole
      ];
      home.packages = with pkgs.kdePackages; [
        dolphin-plugins
        ffmpegthumbs
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
      xdg.dataFile."kxmlgui5/dolphin/dolphinui.rc".source =
        mkSymlink "${dots}/modules/programs/system-utils/dolphin/dolphinui.rc";

      programs.plasma.configFile.dolphinrc = {
        General = {
          DynamicView = true;
          GlobalViewProps = false;
          ShowSelectionToggle = false;
          ShowZoomSlider = true;
          UseTabForSwitchingSplitView = true;
        };
        InformationPanel.dateFormat = "ShortFormat";
        VersionControl.enabledPlugins = "Git";
        PreviewSettings.Plugins = lib.concatStringsSep "," [
          "appimagethumbnail"
          "audiothumbnail"
          "comicbookthumbnail"
          "cursorthumbnail"
          "djvuthumbnail"
          "ebookthumbnail"
          "exrthumbnail"
          "directorythumbnail"
          "imagethumbnail"
          "jpegthumbnail"
          "kraorathumbnail"
          "windowsexethumbnail"
          "windowsimagethumbnail"
          "mltpreview"
          "opendocumentthumbnail"
          "svgthumbnail"
          "textthumbnail"
          "ffmpegthumbs" # pkgs.kdePackages.ffmpegthumbs
        ];
      };
    };

  flake.nixosModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.nixosModules.dolphin ];
  };
  flake.homeModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.homeModules.dolphin ];
  };
}

{
  lib,
  pkgs,
  ...
}: let
  types = import ./types.nix {inherit lib;};
  fontType = types.fontType;
  cursorType = types.cursorType;
  iconType = types.iconType;
in {
  options.nixdots.style = {
    enable = lib.mkEnableOption "Enable theming and font management for applications.";
    mountFHS = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to mount fonts and icons into FHS location for better compatibility.";
    };
    polarity = lib.mkOption {
      type = lib.types.enum ["light" "dark" "auto"];
      default = "dark";
      description = "Overall theme polarity, affecting color scheme and wallpaper selection.";
    };
    stylix = {
      enable = lib.mkEnableOption "Enable stylix for theming and font management.";
      base16Scheme = lib.mkOption {
        type = lib.types.path;
        default = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
        description = "Path to the Base16 color scheme YAML file.";
      };
      wallpaper = lib.mkOption {
        type = lib.types.path;
        description = "Path to the wallpaper image file.";
      };
    };
    fonts = {
      sansSerif = lib.mkOption {
        type = lib.types.listOf fontType;
        default = [
          {
            package = pkgs.nur.repos.guanran928.harmonyos-sans;
            name = "HarmonyOS Sans";
          }
          {
            package = pkgs.lxgw-neoxihei;
            name = "LXGW Neo XiHei";
          }
        ];
        description = "The sans-serif font to use for general UI elements. The first font in the list will be the primary choice, with subsequent fonts as fallbacks.";
      };
      serif = lib.mkOption {
        type = lib.types.listOf fontType;
        default = [
          {
            package = pkgs.lxgw-wenkai;
            name = "LXGW WenKai";
          }
        ];
        description = "The serif font to use for general UI elements. The first font in the list will be the primary choice, with subsequent fonts as fallbacks.";
      };
      editorMono = lib.mkOption {
        type = lib.types.listOf fontType;
        default = [
          {
            package = pkgs.maple-mono.NF-CN;
            name = "Maple Mono NF CN";
          }
          {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrains Mono Nerd Font";
          }
        ];
        description = "The monospace font to use for general UI elements. The first font in the list will be the primary choice, with subsequent fonts as fallbacks. This is the default monospace font used for most applications, including terminal emulators and code editors.";
      };
      displayMono = lib.mkOption {
        type = lib.types.listOf fontType;
        default = [
          {
            package = pkgs.nur.repos.definfo.sarasa-term-sc-nerd;
            name = "Sarasa Term SC Nerd Font";
          }
        ];
        description = ''
          The monospace font to use specifically for displaying monospace text without editing.
          For example, viewing journals or logs.
        '';
      };
      emoji = lib.mkOption {
        type = lib.types.listOf fontType;
        default = [
          {
            package = pkgs.noto-fonts-emoji-blob-bin;
            name = "Blobmoji";
          }
          {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          }
        ];
        description = "The emoji font to use for general UI elements. The first font in the list will be the primary choice, with subsequent fonts as fallbacks.";
      };
      extraFonts = lib.mkOption {
        type = lib.types.listOf fontType;
        default = [
          {
            package = pkgs.noto-fonts-cjk-sans;
            name = "Noto Sans CJK";
          }
          {
            package = pkgs.noto-fonts;
            name = "Noto Sans";
          }
          {
            package = pkgs.vollkorn;
            name = "Vollkorn";
          }
          {
            package = pkgs.font-awesome;
            name = "Font Awesome 6 Free";
          }
        ];
        description = "Additional fonts to install and make available for applications. These fonts won't be set as the default for any specific category, but will be available for users to select in application settings or font pickers.";
      };
    };
    cursor = lib.mkOption {
      type = cursorType;
      default = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };
    icon = lib.mkOption {
      type = iconType;
      default = {
        package = pkgs.papirus-icon-theme;
        light = "Papirus-Light";
        dark = "Papirus-Dark";
      };
    };
  };
}

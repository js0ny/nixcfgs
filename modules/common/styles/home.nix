{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.style;
  fontList =
    cfg.fonts.sansSerif
    ++ cfg.fonts.serif
    ++ cfg.fonts.editorMono
    ++ cfg.fonts.displayMono
    ++ cfg.fonts.emoji
    ++ cfg.fonts.extraFonts;
  fontPkgs = builtins.catAttrs "package" fontList;
in
lib.mkIf cfg.enable {
  home.packages = fontPkgs;
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace =
          builtins.catAttrs "name" cfg.fonts.editorMono ++ builtins.catAttrs "name" cfg.fonts.displayMono;
        serif = builtins.catAttrs "name" cfg.fonts.serif;
        sansSerif = builtins.catAttrs "name" cfg.fonts.sansSerif;
      };
    };
  };
  gtk.gtk4.theme = config.gtk.theme;
  catppuccin = {
    enable = false;
    flavor = "mocha";
    accent = "pink";
    sioyek.enable = true; # Stylix does not support sioyek yet, use ctpn as fallback
  };
}

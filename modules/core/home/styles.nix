{
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
  home.pointerCursor = {
    enable = true;
    dotIcons.enable = false;
    hyprcursor.enable = config.wayland.windowManager.hyprland.enable;
    sway.enable = config.wayland.windowManager.sway.enable;
  };
  xdg.configFile = {
    "gtk-3.0/gtk.css".force = true;
    "gtk-4.0/gtk.css".force = true;
  };
}

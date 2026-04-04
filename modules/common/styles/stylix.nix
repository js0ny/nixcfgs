{
  config,
  lib,
  ...
}: let
  style = config.nixdots.style;
in {
  config = lib.mkIf style.stylix.enable {
    stylix = {
      enable = style.stylix.enable;
      autoEnable = true;

      fonts = {
        sansSerif = builtins.head style.fonts.sansSerif;
        serif = builtins.head style.fonts.serif;
        monospace = builtins.head style.fonts.editorMono;
        emoji = builtins.head style.fonts.emoji;
      };

      cursor = style.cursor;
      icons = {enable = true;} // style.icon;
      base16Scheme = lib.mkForce style.stylix.base16Scheme;
      image = ./wallpaper.jpg;
      # TODO: Add support for "auto"
      polarity = "dark";
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  style = config.nixdots.style;
in
{
  stylix = {
    enable = true;
    autoEnable = style.stylix.enable;
    base16Scheme = lib.mkForce style.stylix.base16Scheme;
    # TODO: Add support for "auto"
    polarity = "dark";
  }
  // lib.optionalAttrs (style.stylix.enable) {
    #    autoEnable = true;
    fonts = {
      sansSerif = builtins.head style.fonts.sansSerif;
      serif = builtins.head style.fonts.serif;
      monospace = builtins.head style.fonts.editorMono;
      emoji = builtins.head style.fonts.emoji;
    };

    cursor = style.cursor;
    icons = {
      enable = true;
    }
    // style.icon;
  };
}

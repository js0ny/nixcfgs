{ pkgs, ... }:
{
  home.packages = [ pkgs.imagemagick ];

  programs.dolphin.services."image-format" = {
    mimeType = "image/*";
    actionOrder = [
      "to-avif"
      "to-webp"
      "to-jpeg"
    ];
    desktopEntryExtra = {
      "X-KDE-Submenu" = "Image Format Conversion";
      "X-KDE-Submenu[CN]" = "图像格式转换";
    };
    actions = {
      to-avif = {
        name = "Convert to AVIF";
        icon = "edit-image";
        exec = "magick \"%f\" \"%f.avif\"";
      };
      to-webp = {
        name = "Convert to WebP";
        icon = "edit-image";
        exec = "magick \"%f\" \"%f.webp\"";
      };
      to-jpeg = {
        name = "Convert to JPEG";
        icon = "edit-image";
        exec = "magick \"%f\" \"%f.jpg\"";
      };
    };
  };
}

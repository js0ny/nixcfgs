{ pkgs, ... }:
let
  desktopName = "org.gnome.Loupe";
in
{
  home.packages = [ pkgs.loupe ];

  services.xremap.config.keymap = [
    {
      name = "Loupe GTK4 Software Remaps N/P";
      application = {
        only = [ desktopName ];
      };
      remap = {
        "p" = "KEY_LEFT";
        "n" = "KEY_RIGHT";
        "KEY_LEFTBRACE" = "KEY_LEFT";
        "KEY_RIGHTBRACE" = "KEY_RIGHT";
      };
    }
  ];
}

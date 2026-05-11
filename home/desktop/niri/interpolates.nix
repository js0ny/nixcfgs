{ config, ... }:
let
  customDirs = config.home.customDirs;
  stylix = config.stylix;
  palette = stylix.generated.palette;
in
/* kdl */ ''
  screenshot-path "${customDirs.screenshots}/Screenshot from %Y-%m-%d %H-%M-%S.png"
  cursor {
      xcursor-theme "default"
      xcursor-size ${toString stylix.cursor.size}
  }
  window-rule {
      shadow {
          on
      }
      clip-to-geometry true
      geometry-corner-radius 20
      draw-border-with-background false
      focus-ring {
          active-gradient from="#${palette.base02}" to="#${palette.base0E}" angle=45
      }
  }
''

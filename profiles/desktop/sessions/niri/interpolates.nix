{ config, ... }:
let
  customDirs = config.home.customDirs;
in
/* kdl */ ''
  screenshot-path "${customDirs.screenshots}/Screenshot from %Y-%m-%d %H-%M-%S.png"
  window-rule {
      shadow {
          on
      }
      clip-to-geometry true
      geometry-corner-radius 20
      draw-border-with-background false
  }
''

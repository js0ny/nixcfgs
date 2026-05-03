{ config, ... }:
let
  customDirs = config.home.customDirs;
  stylix = config.stylix;
in
/* kdl */ ''
  screenshot-path "${customDirs.screenshots}/Screenshot from %Y-%m-%d %H-%M-%S.png"
  cursor {
      xcursor-theme "default"
      xcursor-size ${toString stylix.cursor.size}
  }
''

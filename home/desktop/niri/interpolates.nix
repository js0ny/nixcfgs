{ config, ... }:
let
  customDirs = config.home.customDirs;
in
/* kdl */ ''
  screenshot-path "${customDirs.screenshots}/Screenshot from %Y-%m-%d %H-%M-%S.png"
''

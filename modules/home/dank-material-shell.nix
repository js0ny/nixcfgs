{
  config,
  lib,
  ...
}:
let
  d = config.nixdots;
  enable = d.desktop.wm.shell == "dank-material-shell";
in
lib.mkIf enable {
  home.sessionVariables = {
    DMS_DISABLE_POLKIT = "1";
  };

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
  };
}

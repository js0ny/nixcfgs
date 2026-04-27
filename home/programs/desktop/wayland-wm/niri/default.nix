{
  pkgs,
  config,
  lib,
  ...
}:
let
  xdg-config = config.xdg.configHome;
in
{
  imports = [
    ../.
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  systemd.user.tmpfiles.rules = [
    "f ${xdg-config}/local_test.kdl 0644 ${config.home.username} users -"
  ];

  xdg.configFile."niri/config.kdl".text = ''
    include "${./base.kdl}"
    include "${xdg-config}/local_test.kdl"
    ${import ./keymaps.nix { inherit pkgs lib config; }}
    ${import ./window-rules.nix}
  '';
}

{
  pkgs,
  config,
  lib,
  ...
}:
let
  xdg-config = config.xdg.configHome;
  desktop = config.nixdots.desktop;
  extraCfg = desktop.niri.extraConfig;
in
{
  imports = [
    ../wm-components
  ];

  programs.niri = {
    enable = true;
    package = desktop.niri.package;
  };

  systemd.user.tmpfiles.rules = [
    "f ${xdg-config}/niri/local_test.kdl 0644 ${config.home.username} users -"
  ];

  xdg.configFile."niri/config.kdl".text = ''
    include "${./base.kdl}"
    include "${xdg-config}/niri/local_test.kdl"
    ${import ./keymaps.nix { inherit pkgs lib config; }}
    ${import ./interpolates.nix { inherit config; }}
    ${import ./window-rules.nix}
  ''
  + lib.optionalString (extraCfg != "") "\n${extraCfg}";
}

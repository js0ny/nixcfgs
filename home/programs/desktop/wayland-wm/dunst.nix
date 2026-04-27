{
  lib,
  pkgs,
  config,
  ...
}:
let
  vicinae = config.nixdefs.consts.vicinae;
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        indicate_hidden = "yes";
        dmenu = lib.concatStringsSep " " vicinae.dmenu;
        browser = lib.getExe' pkgs.xdg-utils "xdg-open";
      };
    };
  };
  systemd.user.services.dunst = {
    Install.WantedBy = lib.mkForce [ "niri.service" ];
  };
}

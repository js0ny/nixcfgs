{ lib, pkgs, ... }:
let
  launcher = import ../../vicinae-reg.nix;
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        indicate_hidden = "yes";
        dmenu = lib.concatStringsSep " " launcher.dmenu;
        browser = lib.getExe' pkgs.xdg-utils "xdg-open";
      };
    };
  };
  systemd.user.services.dunst = {
    Install.WantedBy = lib.mkForce [ "niri.service" ];
  };
}

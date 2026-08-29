{ lib, pkgs, ... }:
let
  p = pkgs.hyprmoncfg;
in
{
  systemd.user.services.hyprmoncfgd = {
    Unit = {
      PartOf = lib.mkForce [ "hyprland-after-init.target" ];
      After = lib.mkForce [ "hyprland-after-init.target" ];
    };
    Install.WantedBy = lib.mkForce [ "hyprland-after-init.target" ];
    Service = {
      ExecStart = lib.getExe' p "hyprmoncfgd";
    };
  };
  home.packages = [ p ];

  wayland.windowManager.hyprland.extraConfig = /* lua */ ''
    require('monitors')
  '';
  nixdots.persist.home.directories = [ ".config/hyprmoncfg" ];
}

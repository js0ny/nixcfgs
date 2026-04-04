{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixdots.programs.chromium.enable;
in
  lib.mkIf cfg {
    environment.systemPackages = with pkgs.kdePackages; [
      dolphin
      dolphin-plugins
      kio-admin
    ];
    # See: https://github.com/NixOS/nixpkgs/issues/409986
    environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  }

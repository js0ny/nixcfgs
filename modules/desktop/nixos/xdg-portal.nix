{ pkgs, lib, ... }: {
  xdg.portal = {
    enable = true;
    config.common = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  home-manager.sharedModules = [
    # The behaviour of xdg-portal is override, prioritise NixOS by disabling home-manager module
    { xdg.portal.enable = lib.mkForce false; }
  ];
}

{
  flake.nixosModules.desktop = { pkgs, ... }: {
    xdg.portal = {
      enable = true;
      config.common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
  flake.homeModules.desktop = { lib, config, ... }: {
    xdg.portal = {
      enable = lib.mkForce (!config.nixdots.linux.nixos);
    };
  };
}

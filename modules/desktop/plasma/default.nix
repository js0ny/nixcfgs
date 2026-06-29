{
  flake.nixosModules.plasma = { pkgs, ... }: {
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      kate
      kwallet
      kwallet-pam
      kwalletmanager
      qrca
      kde-gtk-config
      drkonqi # causing crash on sessions other than KDE plasma
    ];
  };
  flake.homeModules.plasma = {
    imports = [ ./module.nix ];
  };
}

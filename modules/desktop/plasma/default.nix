{
  imports = [ ./kderc.nix ];
  flake.nixosModules.plasma = { pkgs, lib, ... }: {
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      # keep-sorted start
      kate
      kde-gtk-config # sync gtk colorscheme with kde settings
      kwallet # kwallet: use gnome-keyring instead
      kwallet-pam
      kwalletmanager
      qrca
      # keep-sorted end
      # drkonqi # causing crash on sessions other than KDE plasma, requiredPackages, cannot be excluded
    ];
    # Force disable drkonqi
    systemd.services."drkonqi-coredump-processor@" = {
      wantedBy = lib.mkForce [ ];
      enable = lib.mkForce false;
    };
  };
  flake.homeModules.plasma = {
    imports = [ ./module.nix ];
  };
}

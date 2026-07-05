{
  flake.nixosModules.cosmic = { pkgs, ... }: {
    services.desktopManager.cosmic.enable = true;
    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-term
      cosmic-wallpapers
      cosmic-reader
      cosmic-player
    ];
  };
}

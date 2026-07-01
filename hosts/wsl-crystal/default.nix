_: {
  system.stateVersion = "25.11";

  imports = [
    # Host-specific configs
    ./vars.nix
  ];

  home-manager.users."js0ny" = import ./home.nix;

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

}

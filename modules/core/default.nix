{
  imports = [
    ./packages.nix
    ./ssh.nix
    ./tailscale.nix
  ];

  flake.nixosModules.core = _: {
    imports = [
      ./nixos.nix
    ];
  };

  flake.homeModules.core = _: {
    home.sessionVariables = import ./do-not-track-vars.nix;
    imports = [
      ./nix.nix
      ./home/sops.nix
    ];
  };

  flake.darwinModules.core = _: {
    environment.variables = import ./do-not-track-vars.nix;
    home-manager.sharedModules = [ { imports = [ ./nix-helper.nix ]; } ];
    imports = [
      ./nix.nix
    ];
  };
}

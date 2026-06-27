{
  imports = [
    ./packages.nix
    ./ssh.nix
  ];
  flake.nixosModules.core = import ./nixos.nix;
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

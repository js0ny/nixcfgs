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

  flake.homeModules.core = { inputs, ... }: {
    home.sessionVariables = import ./do-not-track-vars.nix;
    imports = [
      ./nix.nix
      ./home/antidots.nix
      ./home/configuration.nix
      ./home/cross-platform.nix
      ./home/gpg.nix
      ./home/homebrew.nix
      ./home/sops.nix
      ./home/styles.nix
      ./home/system-alias.nix
      ./home/system-plist.nix
      ./home/xdg-dirs.nix

      inputs.self.homeModules.fastfetch
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

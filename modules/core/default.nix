{
  imports = [
    ./packages.nix
    ./ssh.nix
    ./tailscale.nix
  ];

  flake.nixosModules.core = { inputs, ... }: {
    imports = [
      ./nixos.nix
      inputs.sops-nix.nixosModules.sops
    ];
  };

  flake.homeModules.core = { inputs, ... }: {
    home.sessionVariables = import ./do-not-track-vars.nix;
    imports = [
      ./nix.nix
      ./sops.nix
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

      ../options

      inputs.self.homeModules.git
      inputs.sops-nix.homeManagerModules.sops
    ];
  };

  flake.darwinModules.core = _: {
    environment.variables = import ./do-not-track-vars.nix;
    home-manager.sharedModules = [ { imports = [ ./nix-helper.nix ]; } ];
    imports = [
      ./nix.nix
      ./hm.nix

      ../options
    ];
  };

  flake.homeModules.linux = { inputs, ... }: {
    imports = [
      inputs.self.homeModules.core
      inputs.plasma-manager.homeModules.plasma-manager
    ];
  };

  flake.homeModules.darwin = { inputs, ... }: {
    imports = [
      inputs.self.homeModules.core
    ];
  };
}

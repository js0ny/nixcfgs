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
    home.sessionVariables = import ./shared/do-not-track-vars.nix;
    imports = [
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
    home-manager.sharedModules = [ { imports = [ ./nix-helper.nix ]; } ];
    imports = [
      ./nix.nix
      ./hm.nix
      ./sops.nix
      ../options
    ];
  };

  flake.homeModules.linux = { inputs, ... }: {
    imports = [
      inputs.self.homeModules.core
      inputs.plasma-manager.homeModules.plasma-manager
      ./nix.nix
    ];

  };

  flake.homeModules.darwin = { inputs, pkgs, ... }: {
    imports = [
      inputs.self.homeModules.core
      inputs.plasma-manager.homeModules.plasma-manager
    ];
    nix.package = pkgs.nix;
  };
}

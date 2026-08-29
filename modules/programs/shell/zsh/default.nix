{
  flake = {
    nixosModules.zsh = import ./nixos.nix;
    darwinModules.zsh = import ./darwin.nix;
    homeModules.zsh = import ./home.nix;
  };

}

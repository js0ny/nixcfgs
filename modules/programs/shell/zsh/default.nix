{
  flake = {
    nixosModules.zsh = import ./nixos.nix;
    darwinModules.zsh = import ./darwin.nix;
    homeModules.zsh = import ./home.nix;
    nixosModules.core = { inputs, ... }: {
      imports = [ inputs.self.nixosModules.zsh ];
    };
    homeModules.core = { inputs, ... }: {
      imports = [ inputs.self.homeModules.zsh ];
    };
    darwinModules.core = { inputs, ... }: {
      imports = [ inputs.self.darwinModules.zsh ];
    };
  };

}

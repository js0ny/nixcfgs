{
  flake.homeModules.protonvpn = import ./protonvpn.nix;
  flake.homeModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.homeModules.protonvpn ];
  };
  flake.homeModules.darwin = { inputs, ... }: {
    imports = [ inputs.self.homeModules.protonvpn ];
  };
}

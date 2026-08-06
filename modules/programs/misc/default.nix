{
  flake.homeModules.protonvpn = import ./protonvpn.nix;
  flake.homeModules.rtorrent = import ./rtorrent.nix;
  flake.homeModules.proton-pass = import ./proton-pass.nix;
  flake.homeModules.desktop = { inputs, ... }: {
    imports = [
      inputs.self.homeModules.protonvpn
      inputs.self.homeModules.rtorrent
      inputs.self.homeModules.proton-pass
    ];
  };
  flake.homeModules.darwin = { inputs, ... }: {
    imports = [ inputs.self.homeModules.protonvpn ];
  };
}

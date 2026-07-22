{
  flake.homeModules.protonvpn = import ./protonvpn.nix;
  flake.homeModules.rtorrent = import ./rtorrent.nix;
  flake.homeModules.desktop = { inputs, ... }: {
    imports = [
      inputs.self.homeModules.protonvpn
      inputs.self.homeModules.rtorrent
    ];
  };
  flake.homeModules.darwin = { inputs, ... }: {
    imports = [ inputs.self.homeModules.protonvpn ];
  };
}

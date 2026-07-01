{
  flake.homeModules.linux = import ./linux-base.nix;
  flake.homeModules.server = import ./server-base.nix;
  flake.homeModules.wsl = import ./wsl.nix;
  flake.homeModules.darwin = import ./darwin-base.nix;
  flake.homeModules.desktop-base = import ./desktop-base.nix;
  flake.homeModules.desktop = import ./desktop-extra.nix;
  flake.homeModules.dev = import ./dev.nix;
}

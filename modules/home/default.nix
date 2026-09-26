{
  flake.homeModules.server = import ./server-base.nix;
  flake.homeModules.wsl = import ./wsl.nix;
  flake.homeModules.dev = import ./dev.nix;
}

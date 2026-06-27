{
  flake.homeModules.linux-common = import ../../home/linux-base.nix;
  flake.homeModules.server = import ../../home/server-base.nix;
  flake.homeModules.wsl = import ../../home/wsl.nix;
  flake.homeModules.darwin = import ../../home/darwin-base.nix;
}

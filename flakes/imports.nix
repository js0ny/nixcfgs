{ inputs, ... }: {
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks.flakeModule
    inputs.home-manager.flakeModules.home-manager
  ];
}

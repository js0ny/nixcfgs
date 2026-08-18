{
  flake.darwinModules.core = { inputs, myLib, ... }: {
    imports = myLib.scanPaths ./. ++ [
      inputs.sops-nix.darwinModules.default
    ];
    environment.variables = import ../shared/do-not-track-vars.nix;
  };
}

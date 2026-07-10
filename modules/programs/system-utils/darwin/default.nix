{
  flake.homeModules.darwin-system-enhancement = { myLib, ... }: {
    imports = myLib.scanPaths ./.;
  };
}

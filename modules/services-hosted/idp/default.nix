{
  flake.nixosModules.idp = { myLib, ... }: {
    imports = myLib.scanPaths ./.;
  };
}

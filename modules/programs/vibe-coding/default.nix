{
  flake.homeModules.vibe-coding =
    { myLib, ... }:
    {
      imports = myLib.scanPaths ./.;
    };
}

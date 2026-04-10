{ ... }:
{
  nixpkgs.config.permittedInsecurePackages = [
    "electron-38.8.4"
  ];
}

{
  pkgs,
  lib,
  myLib,
  nixcfgs,
  inputs,
  secrets,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupCommand = lib.getExe pkgs.trash-cli;
    extraSpecialArgs = {
      inherit
        inputs
        nixcfgs
        myLib
        secrets
        ;
    };
    sharedModules = [
      #  inputs.dank-material-shell.homeModules.default
    ];
  };
}

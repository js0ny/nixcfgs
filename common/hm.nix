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
    backupCommand = lib.getExe pkgs.trashy;
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

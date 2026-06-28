{
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
    backupCommand = "rm";
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
      inputs.catppuccin.homeModules.catppuccin
    ];
  };
}

{
  myLib,
  nixcfgs,
  inputs,
  secrets,
  pkgsStable,
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
        pkgsStable
        ;
    };
    sharedModules = [
      #  inputs.dank-material-shell.homeModules.default
      inputs.catppuccin.homeModules.catppuccin
      inputs.plasma-manager.homeModules.plasma-manager
    ];
  };
}

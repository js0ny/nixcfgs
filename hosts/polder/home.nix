{
  inputs,
  nixcfgs,
  ...
}:
{
  imports = [
    nixcfgs.homeManagerModules.server-base
    inputs.sops-nix.homeManagerModules.sops
    ./vars.nix
  ];

  home.stateVersion = "25.05";
}

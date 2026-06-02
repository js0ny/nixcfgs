{
  inputs,
  nixcfgs,
  ...
}:
{
  imports = [
    ../../home/server-base.nix
    inputs.sops-nix.homeManagerModules.sops
    ./vars.nix
  ];

  home.stateVersion = "25.05";
}

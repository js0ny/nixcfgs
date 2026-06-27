{
  inputs,
  nixcfgs,
  ...
}:
{
  imports = [
    inputs.self.homeModules.server
    inputs.sops-nix.homeManagerModules.sops
    ./vars.nix
  ];

  home.stateVersion = "25.05";
}

{
  pkgs,
  config,
  inputs,
  nixcfgs,
  secrets,
  ...
}:
{
  imports = [
    inputs.self.homeModules.server
    inputs.sops-nix.homeManagerModules.sops
    ./vars.nix
  ];

  home.stateVersion = "26.05";
}

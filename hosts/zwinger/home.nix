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
    nixcfgs.homeManagerModules.server-base
    inputs.sops-nix.homeManagerModules.sops
    ./vars.nix
  ];

  home.stateVersion = "26.05";
}

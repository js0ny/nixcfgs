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
    ../../home/server-base.nix
    inputs.sops-nix.homeManagerModules.sops
    ./vars.nix
  ];

  home.stateVersion = "26.05";
}

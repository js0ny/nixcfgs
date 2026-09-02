{ inputs, ... }:
{
  imports = [
    inputs.self.homeModules.server
    inputs.sops-nix.homeManagerModules.sops
    ./vars.nix
  ];

  home.stateVersion = "26.11";
  sops.age.keyFile = "/persist/etc/ssh/agekey.txt";
}

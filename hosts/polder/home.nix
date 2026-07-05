{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.self.homeModules.server
    inputs.sops-nix.homeManagerModules.sops

    inputs.self.homeModules.starship
    inputs.self.homeModules.neovim
    ./vars.nix
  ];

  home.stateVersion = "25.05";
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
}

{
  flake.nixosModules.starship = _: {
    programs.starship = {
      enable = true;
      interactiveOnly = true;
    };
  };
  flake.homeModules.starship = import ./home.nix;
}

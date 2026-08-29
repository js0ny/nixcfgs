{
  config,
  inputs,
  ...
}:
let
  modules = config.flake;
in
{
  flake.nixosModules.core = { myLib, ... }: {
    imports = [
      ./nixos.nix
      ./shared/hm.nix
      ./shared/nix.nix
      ./shared/nix-helper.nix
      ./shared/sops.nix
      inputs.sops-nix.nixosModules.sops
      modules.nixosModules.git
      modules.nixosModules.hardware
      modules.nixosModules.yazi
      modules.nixosModules.zsh
    ]
    ++ myLib.scanFiles ./nixos;
  };

  flake.homeModules.core = { myLib, ... }: {
    home.sessionVariables = import ./shared/do-not-track-vars.nix;
    imports = [
      ./shared/sops.nix
      ../../modules/options
      inputs.sops-nix.homeManagerModules.sops
      modules.homeModules.fastfetch
      modules.homeModules.git
      modules.homeModules.yazi
      modules.homeModules.zsh
    ]
    ++ myLib.scanFiles ./home;
  };

  flake.darwinModules.core = { myLib, ... }: {
    home-manager.sharedModules = [ { imports = [ ./shared/nix-helper.nix ]; } ];
    imports = [
      ./shared/nix.nix
      ./shared/sops.nix
      ../../modules/options
      modules.darwinModules.zsh
    ]
    ++ myLib.scanFiles ./darwin;
  };

  flake.homeModules.linux = { myLib, ... }: {
    imports = [
      ./shared/nix.nix
      inputs.plasma-manager.homeModules.plasma-manager
      modules.homeModules.core
    ]
    ++ myLib.scanFiles ./home/linux;
  };

  flake.homeModules.darwin =
    { myLib, pkgs, ... }:
    {
      imports = [
        inputs.plasma-manager.homeModules.plasma-manager
        modules.homeModules.core
        modules.homeModules.fish
        modules.homeModules.modern-unix
        modules.homeModules.protonvpn
      ]
      ++ myLib.scanFiles ./home/darwin;
      nix.package = pkgs.nix;
    };
}

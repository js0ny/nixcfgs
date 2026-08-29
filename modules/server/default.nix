{
  flake.nixosModules.nginx = import ./nginx.nix;

  flake.nixosModules.server = _: {
  };

  flake.homeModules.server = { inputs, lib, ... }: {
    programs.plasma.enable = lib.mkForce false;
    dconf.enable = false;
    imports = [
      inputs.self.homeModules.linux
    ];
  };
}

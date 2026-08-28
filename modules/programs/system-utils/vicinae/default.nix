{
  flake.nixosModules.vicinae =
    { config, ... }:
    let
      username = config.js0ny.user.name;
    in
    {
      # uinput is required for clipboard integration
      boot.kernelModules = [ "uinput" ];
      js0ny.user.groups = [
        "input"
        "uinput"
      ];
    };
  flake.homeModules.vicinae = import ./home.nix;
  flake.nixosModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.nixosModules.vicinae ];
  };
  flake.homeModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.homeModules.vicinae ];
  };
}

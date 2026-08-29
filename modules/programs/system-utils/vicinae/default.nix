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
}

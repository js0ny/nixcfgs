{
  flake.nixosModules.vicinae =
    { config, ... }:
    let
      username = config.nixdots.user.name;
    in
    {
      # uinput is required for clipboard integration
      boot.kernelModules = [ "uinput" ];
      users.users."${username}".extraGroups = [
        "input"
        "uinput"
      ];
    };
  flake.homeModules.vicinae = import ./home.nix;
}

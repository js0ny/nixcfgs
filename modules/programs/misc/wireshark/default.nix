{
  flake.nixosModules.wireshark =
    { pkgs, config, ... }:
    let
      user = config.js0ny.user.name;
    in
    {
      programs.wireshark = {
        enable = true;
        package = if config.hardware.graphics.enable then pkgs.wireshark else pkgs.wireshark-cli;
      };
      users.users.${user}.extraGroups = [ "wireshark" ];

    };
}

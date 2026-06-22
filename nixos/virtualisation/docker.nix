{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdots.machine.virtualisation.oci-container.docker;
  username = config.nixdots.user.name;
in
lib.mkIf cfg {

  virtualisation.docker = {
    enable = true;
    enableOnBoot = lib.mkDefault true;
    rootless.enable = true;
  };

  users.users."${username}" = {
    extraGroups = [ "docker" ];
  };
}

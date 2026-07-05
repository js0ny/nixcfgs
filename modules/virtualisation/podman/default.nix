{
  flake.nixosModules.podman =
    {
      config,
      lib,
      ...
    }:
    let
      dockerEnabled = config.virtualisation.docker.enable;
    in
    {
      virtualisation.podman = {
        enable = true;
        dockerCompat = lib.mkDefault (!dockerEnabled);
        dockerSocket.enable = lib.mkDefault (!dockerEnabled);
      };
    };

}
# Docker
/*
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
*/

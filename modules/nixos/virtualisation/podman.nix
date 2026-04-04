{
  config,
  lib,
  ...
}: let
  cfg = config.nixdots.machine.virtualisation.oci-container.podman;
  username = config.nixdots.user.name;
in
  lib.mkIf cfg {
    virtualisation = {
      podman.enable = true;
    };
    users.users."${username}" = {
      extraGroups = ["podman"];
    };
  }

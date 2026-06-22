{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdots.machine.virtualisation.oci-container.podman;
  dockerEnabled = config.virtualisation.docker.enable;
in
lib.mkIf cfg {
  virtualisation.podman = {
    enable = true;
    dockerCompat = lib.mkDefault (!dockerEnabled);
    dockerSocket.enable = lib.mkDefault (!dockerEnabled);
  };
}

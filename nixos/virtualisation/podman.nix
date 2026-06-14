{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdots.machine.virtualisation.oci-container.podman;
in
lib.mkIf cfg {
  virtualisation.podman.enable = true;
}

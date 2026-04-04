{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.nixdots.server.enable {
  # TODO: Split to `guest`
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  # Server config
  time.timeZone = "Etc/UTC";
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";
  nixpkgs.config.allowUnfree = true;
}

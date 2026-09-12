{
  flake.nixosModules.podman =
    {
      config,
      lib,
      pkgs,
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
      environment.systemPackages = [ pkgs.podman-compose ];
      virtualisation.oci-containers.backend = "podman";
    };
}

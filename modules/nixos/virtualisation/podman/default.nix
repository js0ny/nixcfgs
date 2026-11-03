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
      key = "nixcfgs.nixosModules.podman";

      virtualisation.podman = {
        enable = true;
        dockerCompat = lib.mkDefault (!dockerEnabled);
        dockerSocket.enable = lib.mkDefault (!dockerEnabled);
      };
      environment.systemPackages = [ pkgs.podman-compose ];
      # https://github.com/containers/image/blob/main/docs/containers-registries.conf.5.md
      virtualisation.containers.registries.settings = {
        unqualified-search-registries = [ "docker.io" ];
      };
      virtualisation.oci-containers.backend = "podman";
    };
}

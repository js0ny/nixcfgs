{
  flake.nixosModules.valheim =
    {
      config,
      lib,
      secrets,
      ...
    }:
    let
      stateDir = "/var/lib/valheim";
    in
    {
      imports = [ ./backup.nix ];

      sops.secrets = {
        valheim_password.sopsFile = secrets + "/hosts/belvedere.yaml";
        valheim_admins.sopsFile = secrets + "/hosts/belvedere.yaml";
      };
      sops.templates."valheim.env".content = /* bash */ ''
        ADMINLIST_IDS="${config.sops.placeholder.valheim_admins}"
      '';

      virtualisation.oci-containers.containers.valheim = {
        image = "ghcr.io/community-valheim-tools/valheim-server:latest";
        environment = {
          SERVER_NAME = "belvedere";
          WORLD_NAME = "belvedere";
          SERVER_PUBLIC = "true";
          CROSSPLAY = "false";
          SERVER_PASS_FILE = "/run/secrets/valheim_password";
          TZ = "Europe/Vienna";
          # MOD Manager
          BEPINEX = "false";
          VALHEIM_PLUS = "true";
          VALHEIM_PLUS_REPO = "Grantapher/ValheimPlus";
          VALHEIM_PLUS_RELEASE = "tags/0.10.2.0";
        };
        environmentFiles = [ config.sops.templates."valheim.env".path ];
        ports = [
          "2456:2456/udp"
          "2457:2457/udp"
        ];
        volumes = [
          "${stateDir}/config:/config"
          "${stateDir}/data:/opt/valheim"
          "${config.sops.secrets.valheim_password.path}:/run/secrets/valheim_password:ro"
        ];
        extraOptions = [ "--stop-timeout=120" ];
      };

      systemd.services.podman-valheim = {
        unitConfig.RequiresMountsFor = [ stateDir ];
        serviceConfig = {
          StateDirectory = [
            "valheim/config"
            "valheim/data"
          ];
          StateDirectoryMode = "0750";
          TimeoutStopSec = lib.mkForce 150;
        };
      };
      networking.firewall.allowedUDPPorts = [
        2456
        2457
      ];
      js0ny.persist.stores.state.directories = [ stateDir ];
    };
}

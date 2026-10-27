{
  flake.nixosModules.marimohub =
    {
      config,
      inputs,
      lib,
      myLib,
      pkgs,
      secrets,
      ...
    }:
    let
      ep = config.nixdefs.endpoints.marimohub;
      stateDir = "/var/lib/marimohub";
    in
    {
      imports = [ inputs.self.nixosModules.podman ];

      nixdefs.endpoints.marimohub.port = lib.mkDefault 3000;

      sops.secrets.marimohub_session_secret = {
        sopsFile = secrets + "/marimohub.yaml";
      };
      sops.templates."marimohub.env" = {
        content = myLib.attrsToEnvFile {
          MARIMOHUB_AUTH_SESSION_SECRET = config.sops.placeholder.marimohub_session_secret;
        };
        mode = "0400";
        restartUnits = [ "podman-marimohub.service" ];
      };

      virtualisation.oci-containers.containers.marimohub = {
        image = "ghcr.io/marimo-team/marimohub:0.5.3@sha256:d9fa187be84625ac2953f810ae7646b3e31c99c1f70ddc6a7ffe57f4a9fba563";
        # https://github.com/marimo-team/marimohub/blob/v0.5.3/docs/configuration.md
        environment = {
          PORT = ep.portStr;
          MARIMOHUB_BIND_HOST = ep.bindAddress;
          MARIMOHUB_APP_BASE_URL = lib.mkDefault (
            if ep.publicUrl != null then ep.publicUrl else "http://${ep.listenStr}"
          );

          MARIMOHUB_STORAGE_BACKEND = "fs";
          MARIMOHUB_STORAGE_FS_ROOT = "/var/lib/marimohub/storage";
          MARIMOHUB_COMPUTE_BACKEND = "podman";
          MARIMOHUB_COMPUTE_IMAGE = "ghcr.io/marimo-team/marimo-sandbox:py3.13-marimo0.25.2@sha256:4a368e06fc1b161687070b1b1fe7427f7ee9fd1906bc50be083f720e5ac6e5b5";
          MARIMOHUB_COMPUTE_PODMAN_HOST = "127.0.0.1";
          MARIMOHUB_COMPUTE_PODMAN_BIND_HOST = "127.0.0.1";
          MARIMOHUB_COMPUTE_PODMAN_OWNER_TAG = "marimohub-${config.networking.hostName}";
          MARIMOHUB_SANDBOX_EXPOSURE = "proxy";
          # Proxied notebooks share the Hub's origin; only trusted users may access it.
          MARIMOHUB_SANDBOX_PROXY_ACK_UNTRUSTED = "true";
          MARIMOHUB_RUN_MAINTENANCE = "true";

          CONTAINER_HOST = "unix:///run/podman/podman.sock";
          PATH = "${
            lib.makeBinPath [ pkgs.podman ]
          }:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
        };
        environmentFiles = [ config.sops.templates."marimohub.env".path ];
        volumes = [
          "${stateDir}/storage:/var/lib/marimohub/storage"
          # The upstream image lacks Podman; its Nix CLI needs its runtime closure.
          "/nix/store:/nix/store:ro"
          # This socket grants host-root-equivalent access; never mount it in kernels.
          "/run/podman/podman.sock:/run/podman/podman.sock"
        ];
        extraOptions = [
          "--network=host"
          "--stop-timeout=140"
        ];
      };

      systemd.services.podman-marimohub = {
        requires = [
          "podman.socket"
        ]
        ++ lib.optional config.sops.useSystemdActivation "sops-install-secrets.service";
        after = [
          "podman.socket"
        ]
        ++ lib.optional config.sops.useSystemdActivation "sops-install-secrets.service";
        unitConfig = {
          RequiresMountsFor = [ stateDir ];
          StartLimitIntervalSec = 0;
        };
        serviceConfig = {
          StateDirectory = "marimohub/storage";
          StateDirectoryMode = "0700";
          RestartSec = 5;
          TimeoutStopSec = lib.mkForce 160;
        };
      };

      systemd.tmpfiles.rules = [
        "d ${stateDir} 0700 root root -"
        "d ${stateDir}/storage 0700 root root -"
      ];
      js0ny.persist.stores.state.directories = [ stateDir ];
    };
}

{
  flake.nixosModules.forgejo-runner =
    {
      config,
      lib,
      pkgs,
      secrets,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      wantsDocker = config.virtualisation.docker.enable;
      wantsPodman = config.virtualisation.podman.enable && !wantsDocker;
      containerUnits =
        lib.optionals wantsDocker [ "docker.service" ] ++ lib.optionals wantsPodman [ "podman.socket" ];
      containerGroups = lib.optionals wantsDocker [ "docker" ] ++ lib.optionals wantsPodman [ "podman" ];
      labels = [
        "debian-latest:docker://node:22-bookworm"
        "ubuntu-latest:docker://node:22-bookworm"
      ];
      labelArgs = lib.concatMapStringsSep " " (label: "--label ${lib.escapeShellArg label}") labels;
      settingsFormat = pkgs.formats.yaml { };
      configFile = settingsFormat.generate "forgejo-runner.yaml" {
        log = {
          level = "info";
          job_level = "info";
        };
        runner = {
          capacity = 1;
        };
        container = {
          docker_host = if wantsPodman then "unix:///run/podman/podman.sock" else "automount";
        };
      };
      startScript = pkgs.writeShellScript "forgejo-runner-main" ''
        uuid="$(<"$CREDENTIALS_DIRECTORY/uuid")"

        exec ${lib.getExe pkgs.forgejo-runner} daemon \
          --config ${lib.escapeShellArg configFile} \
          --url ${lib.escapeShellArg ep.forgejo.publicUrl} \
          --uuid "$uuid" \
          --token-url 'file:$CREDENTIALS_DIRECTORY/token' \
          ${labelArgs}
      '';
    in
    lib.mkIf (ep.forgejo.publicUrl != null) {
      virtualisation.podman.dockerSocket.enable = lib.mkIf wantsPodman (lib.mkDefault true);

      sops.secrets.forgejo_runner_uuid = {
        sopsFile = secrets + /forgejo.yaml;
      };

      sops.secrets.forgejo_runner_token = {
        sopsFile = secrets + /forgejo.yaml;
      };

      systemd.services.forgejo-runner-main = {
        description = "Forgejo Actions Runner";
        wants = [ "network-online.target" ] ++ containerUnits;
        after = [ "network-online.target" ] ++ containerUnits;
        wantedBy = [ "multi-user.target" ];
        environment = {
          HOME = "/var/lib/gitea-runner/main";
        };
        serviceConfig = {
          DynamicUser = true;
          User = "forgejo-runner";
          StateDirectory = "gitea-runner";
          WorkingDirectory = "-/var/lib/gitea-runner/main";
          ExecStartPre = "${lib.getExe' pkgs.coreutils "mkdir"} -p /var/lib/gitea-runner/main";
          ExecStart = startScript;
          LoadCredential = [
            "uuid:${config.sops.secrets.forgejo_runner_uuid.path}"
            "token:${config.sops.secrets.forgejo_runner_token.path}"
          ];
          Restart = "on-failure";
          RestartSec = 2;
          SupplementaryGroups = containerGroups;
        };
      };

      nixdots.persist.system.directories = [ "/var/lib/gitea-runner" ];
    };
}

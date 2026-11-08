{
  config,
  lib,
  pkgs,
  ...
}:
let
  user = config.js0ny.user.name;
  uid = config.users.users.${user}.uid;
  stateDir = "/var/lib/openmausbot";
  host = config.js0ny.tailscale.magicDNS;
  origin = "https://${host}";
  image = "localhost/openmausbot-local:v0.1.142";
  podman = lib.getExe pkgs.podman;
  systemctl = lib.getExe' config.systemd.package "systemctl";
  composeFile = pkgs.writeText "openmausbot-compose.json" (
    builtins.toJSON {
      name = "openmausbot";
      services = {
        omb = {
          inherit image;
          init = true;
          shm_size = "512m";
          build = {
            context = pkgs.writeTextDir "Dockerfile" (builtins.readFile ./Dockerfile);
            args = {
              BASE_IMAGE = "ghcr.io/milind-soni/openmausbot:v0.1.142@sha256:2c81f8feff5fddf9e2da72607ba336a27866a07812e9604b7fbef7912ee932cf";
              ENGINES = lib.concatStringsSep " " [
                "@anthropic-ai/claude-code@2.1.318"
                "@openai/codex@0.166.0"
              ];
            };
          };
          restart = "unless-stopped";
          volumes = [ "${stateDir}/data:/data" ];
          network_mode = "host";
          environment = {
            OMB_PORT = "8799";
            OMB_PUBLIC_URL = origin;
          };
          healthcheck = {
            test = [
              "CMD"
              "node"
              "-e"
              "fetch('http://127.0.0.1:8799/api/health', { signal: AbortSignal.timeout(4000) }).then(async r => { if (!r.ok || !(await r.text()).includes('openmausbot')) process.exit(1); }).catch(() => process.exit(1))"
            ];
            interval = "15s";
            timeout = "5s";
            start_period = "30s";
            retries = 5;
          };
        };
      };
    }
  );
  compose = pkgs.writeShellApplication {
    name = "openmausbot-compose";
    text = /* bash */ ''
      export PODMAN_COMPOSE_PROVIDER=${lib.getExe pkgs.docker-compose}
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
      exec ${podman} compose --file ${composeFile} "$@"
    '';
  };
  composeCommand = args: lib.escapeShellArgs ([ (lib.getExe compose) ] ++ args);
in
{
  assertions = [
    {
      assertion = config.virtualisation.podman.enable && config.services.tailscale.enable;
      message = "OpenMausBot requires Podman and Tailscale.";
    }
  ];

  users.users.${user}.linger = true;
  environment.systemPackages = [ compose ];
  systemd.tmpfiles.rules = [ "d ${stateDir} 0700 ${user} ${config.users.users.${user}.group} -" ];
  js0ny.persist.stores.state.directories = [
    {
      directory = stateDir;
      inherit user;
      group = config.users.users.${user}.group;
      mode = "0700";
    }
  ];
  # [Human Intervention] Enable Tailnet HTTPS, pair devices and connect AI accounts on first setup.
  systemd.services.openmausbot = {
    description = "OpenMausBot rootless Compose stack";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    requires = [ "user@${toString uid}.service" ];
    after = [
      "network-online.target"
      "user@${toString uid}.service"
    ];
    unitConfig.RequiresMountsFor = stateDir;
    environment = {
      HOME = config.js0ny.user.home;
      XDG_RUNTIME_DIR = "/run/user/${toString uid}";
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = user;
      Group = config.users.users.${user}.group;
      WorkingDirectory = stateDir;
      UMask = "0077";
      TimeoutStartSec = "15min";
      TimeoutStopSec = "2min";
      ExecStartPre = [
        "${systemctl} --user start podman.socket"
        "${lib.getExe' pkgs.coreutils "mkdir"} -p ${stateDir}/data"
        # The image's maus account uses uid/gid 1001 inside Podman's user namespace.
        "${podman} unshare chown 1001:1001 ${stateDir}/data"
        # The previous sidecar must be removed before its network namespace owner.
        "${podman} rm --force --ignore openmausbot-caddy-1"
        (composeCommand [
          "down"
          "--remove-orphans"
        ])
        (composeCommand [ "build" ])
      ];
      ExecStart = composeCommand [
        "up"
        "-d"
        "--no-build"
        "--wait"
        "--wait-timeout"
        "120"
      ];
      ExecStop = composeCommand [ "down" ];
    };
  };

  systemd.services.openmausbot-https = {
    description = "OpenMausBot Tailnet HTTPS endpoint";
    wantedBy = [ "multi-user.target" ];
    requires = [ "tailscaled.service" ];
    after = [ "tailscaled.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = lib.escapeShellArgs [
        (lib.getExe pkgs.tailscale)
        "serve"
        "--bg"
        "--yes"
        "--https=443"
        "http://127.0.0.1:8799"
      ];
    };
  };

  systemd.services.openmausbot-backup = {
    description = "Back up OpenMausBot data while its writers are stopped";
    conflicts = [ "openmausbot.service" ];
    after = [ "openmausbot.service" ];
    path = [ pkgs.gzip ];
    serviceConfig = {
      Type = "oneshot";
      UMask = "0077";
      ExecStart = [
        "${lib.getExe pkgs.gnutar} --create --gzip --file=${stateDir}/backup.tar.gz.tmp --directory=${stateDir} data"
        "${lib.getExe' pkgs.coreutils "mv"} ${stateDir}/backup.tar.gz.tmp ${stateDir}/backup.tar.gz"
      ];
      ExecStopPost = "${systemctl} --no-block start openmausbot.service";
    };
  };
  systemd.timers.openmausbot-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:15:00";
      Persistent = true;
    };
  };
}

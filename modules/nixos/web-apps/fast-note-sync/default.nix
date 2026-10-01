{
  flake.nixosModules.fast-note-sync =
    {
      config,
      lib,
      pkgs,
      secrets,
      ...
    }:
    let
      epSelf = config.nixdefs.endpoints.fast-note-sync;
      url = epSelf.domain;
      portStr = epSelf.portStr;
      stateDir = "/var/lib/fast-note-sync-service";
      user = "fast-note-sync";
    in
    {
      users.users.${user} = {
        isSystemUser = true;
        group = user;
      };
      users.groups.${user} = { };

      sops.secrets.fast_note_sync_auth_token_key.sopsFile = secrets + "/fast-note-sync.yaml";
      sops.templates."fast-note-sync-service.yaml" = {
        owner = user;
        group = user;
        mode = "0400";
        restartUnits = [ "fast-note-sync-service.service" ];
        # https://github.com/haierkeys/fast-note-sync-service/blob/master/config/config.yaml
        content = /* yaml */ ''
          server:
            run-mode: release
            http-port: "${epSelf.bindAddress}:${portStr}"
          security:
            auth-token-key: "${config.sops.placeholder.fast_note_sync_auth_token_key}"
          user:
            register-is-enable: false
            admin-uid: 1 # first user registers as admin
          git:
            name: "[Bot] Fast Note Sync"
            email: "bot@js0ny.net"
        '';
      };

      systemd.tmpfiles.rules = [
        "d ${stateDir} 0700 ${user} ${user} -"
        "d ${stateDir}/storage 0700 ${user} ${user} -"
      ];

      systemd.services.fast-note-sync-service = {
        description = "Fast Note Sync Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          User = user;
          Group = user;
          WorkingDirectory = stateDir;
          ExecStart = lib.escapeShellArgs [
            (lib.getExe pkgs.js0ny.fast-note-sync-service)
            "run"
            "-c"
            (config.sops.templates."fast-note-sync-service.yaml".path)
          ];

          Restart = "on-failure";
        };
      };

      js0ny.persist.stores.state.directories = [
        {
          directory = stateDir;
          inherit user;
          group = user;
          mode = "0700";
        }
      ];

      services.nginx.virtualHosts = lib.mkIf (url != null) {
        ${url} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:${portStr}";
            proxyWebsockets = true;
          };
        }
        // config.nixdefs.consts.nginxWithCF;
      };
    };
}

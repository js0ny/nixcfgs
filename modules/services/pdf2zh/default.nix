{
  flake.nixosModules.pdf2zh =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      pdf2zhPortStr = config.nixdefs.endpoints.pdf2zh.portStr;
      autheliaPortStr = config.nixdefs.endpoints.authelia.portStr;
      pdf2zh = pkgs.writeShellApplication {
        name = "pdf2zh";
        runtimeInputs = with pkgs; [
          uv
          stdenv.cc
        ];
        text = ''
          uvx --python=cp312 --from pdf2zh-next pdf2zh2 "$@"
        '';
      };
    in
    {
      # listens to 0.0.0.0:7860 by default, no customisable options for address
      systemd.services.pdf2zh = {
        description = "PDF scientific paper translation with preserved formats";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${lib.getExe pdf2zh} --gui --server-port=${pdf2zhPortStr}";
          StateDirectory = "pdf2zh";
          WorkingDirectory = "/var/lib/pdf2zh";
          User = "pdf2zh";
          Group = "pdf2zh";
          Restart = "always";
          RestartSec = 5;
          AmbientCapabilities = "";
          CapabilityBoundingSet = "";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          # ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallErrorNumber = "EPERM";
          SystemCallFilter = [
            "@system-service"
            "~@clock @cpu-emulation @debug @module @mount @obsolete @privileged @raw-io @reboot @swap"
          ];
        };
      };
      services.nginx.virtualHosts."pdf2zh.js0ny.net" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${pdf2zhPortStr}";
          proxyWebsockets = true;
          extraConfig = /* nginx */ ''
            auth_request /internal/authelia/authz;
            auth_request_set $redirect $upstream_http_location;
            error_page 401 =302 $redirect;
          '';
        };
        locations."/internal/authelia/authz" = {
          proxyPass = "http://127.0.0.1:${autheliaPortStr}/api/authz/auth-request";
          extraConfig = /* nginx */ ''
            internal;
            proxy_pass_request_body off;
            proxy_set_header Content-Length "";
            proxy_set_header X-Original-Method $request_method;
            proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
            proxy_set_header X-Forwarded-Method $request_method;
            proxy_set_header X-Forwarded-Uri $request_uri;
          '';
        };
      }
      // config.nixdefs.consts.nginxWithCF;

      users.users.pdf2zh = {
        isSystemUser = true;
        group = "pdf2zh";
        home = "/var/lib/pdf2zh";
      };
      users.groups.pdf2zh = { };
      nixdots.persist.system.directories = [ "/var/lib/pdf2zh" ];
    };
}

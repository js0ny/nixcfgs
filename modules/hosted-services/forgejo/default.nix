{
  flake.nixosModules.forgejo =
    {
      lib,
      config,
      secrets,
      inputs,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      url = ep.forgejo.domain;
      socketPath = "/run/forgejo/forgejo.sock";
      sopsFile = secrets + /forgejo.yaml;
    in
    {
      imports = [
        inputs.forgejo-file-icons.nixosModules.default
        ./backup.nix
      ];
      services.forgejo-file-icons.enable = true;
      sops.secrets = {
        forgejo_metrics_token = {
          inherit sopsFile;
          owner = "prometheus";
          group = "prometheus";
        };
      };
      environment.systemPackages = [ config.services.forgejo.package ];
      services.forgejo = {
        enable = true;
        # Default: https://codeberg.org/forgejo/forgejo/src/branch/forgejo/custom/conf/app.example.ini
        # Doc: https://forgejo.org/docs/v15.0/admin/config-cheat-sheet
        settings = {
          server = {
            DISABLE_SSH = false;
            PROTOCOL = "http+unix";
            HTTP_ADDR = socketPath;
            SSH_PORT = 2220;
            SSH_LISTEN_PORT = 2220;
            START_SSH_SERVER = true;
            # Hardcoded template for cross-generation binary stability
            # Use together with forgejo's internal ssh server
            SSH_AUTHORIZED_KEYS_COMMAND_TEMPLATE = /* bash */ "/run/current-system/sw/bin/forgejo --config={{.CustomConf}}  serv key-{{.Key.ID}}";
          }
          // lib.optionalAttrs (url != null) {
            ROOT_URL = "https://${url}/";
            DOMAIN = url;
            SSH_DOMAIN = url;
            COOKIE_SECURE = true;
            SESSION_LIFE_TIME = 604800; # hours (7d)
          };
          service = {
            DISABLE_REGISTRATION = true;
          };
          log = {
            MODE = "console, file";
            LEVEL = "Info";
            LOGGER_SSH_MODE = "console, file";
          };
          metrics = {
            ENABLED = true;
          };
        };
        secrets = {
          metrics.TOKEN = config.sops.secrets.forgejo_metrics_token.path;
        };
        lfs.enable = true;
      };
      services.nginx.virtualHosts = lib.mkIf (url != null) {
        "${url}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://unix:${socketPath}:/";
          };
        };
      };
      catppuccin = {
        forgejo.enable = true;
        accent = "pink";
        flavor = "mocha";
      };

      networking.firewall.allowedTCPPorts = [ 2220 ];
      nixdots.persist.system.directories = [ config.services.forgejo.stateDir ];
    };
}

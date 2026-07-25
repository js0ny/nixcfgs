{
  flake.nixosModules.forgejo =
    { lib, config, ... }:
    let
      ep = config.nixdefs.endpoints;
      url = ep.forgejo.domain;
      socketPath = "/run/forgejo/forgejo.sock";
    in
    {
      environment.systemPackages = [ config.services.forgejo.package ];
      services.forgejo = {
        enable = true;
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
          };
          service = {
            DISABLE_REGISTRATION = true;
          };
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
    };
}

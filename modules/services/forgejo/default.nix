{
  flake.nixosModules.forgejo =
    { lib, config, ... }:
    let
      ep = config.nixdefs.endpoints;
      url = ep.forgejo.domain;
      socketPath = "/run/forgejo/forgejo.sock";
    in
    {
      services.forgejo = {
        enable = true;
        settings = {
          server = {
            PROTOCOL = "http+unix";
            HTTP_ADDR = socketPath;
          }
          // lib.optionalAttrs (url != null) {
            ROOT_URL = "https://${url}";
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

    };
}

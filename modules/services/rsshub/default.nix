{
  flake.nixosModules.rsshub =
    {
      pkgs,
      config,
      lib,
      secrets,
      ...
    }:
    let
      dataDir = "/var/lib/rsshub";
      ep = config.nixdefs.endpoints;
      epSelf = ep.rsshub;
      portStr = epSelf.portStr;
      url = epSelf.domain;
    in
    {
      sops.secrets.rsshub_env = {
        sopsFile = secrets + /rsshub.yaml;
        key = "env";
      };

      services.rsshub = {
        enable = true;
        secretFiles = [ config.sops.secrets.rsshub_env.path ];
        settings = {
          PUPPETEER_EXECUTABLE_PATH = lib.getExe pkgs.chromium;
          PUPPETEER_CACHE_DIR = "${dataDir}/.cache/puppeteer";
          NODE_ENV = "production";
          PORT = epSelf.port;
          DISALLOW_ROBOT = "1";
        };
      };

      services.nginx.virtualHosts = lib.mkIf (url != null) {
        ${url} = {
          locations."/" = {
            proxyPass = "http://localhost:${portStr}";
          };
        }
        // config.nixdefs.consts.nginxWithCF;
      };
    };
}

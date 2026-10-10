{
  flake.nixosModules.searxng =
    {
      pkgs,
      lib,
      config,
      secrets,
      myLib,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      epSelf = ep.searxng;
      url = epSelf.domain;
      portStr = epSelf.portStr;
      port = epSelf.port;
    in
    {
      imports = myLib.scanPaths ./.;
      sops.secrets = {
        searxng_secret.sopsFile = secrets + "/searxng.yaml";
        brave_search_api_key.sopsFile = secrets + "/searxng.yaml";
      };

      sops.templates."searxng.env".content = myLib.attrsToEnvFile {
        SEARXNG_SECRET = config.sops.placeholder.searxng_secret;
        BRAVE_SEARCH_API_KEY = config.sops.placeholder.brave_search_api_key;
      };

      services.searx = {
        enable = true;
        redisCreateLocally = true;
        environmentFile = config.sops.templates."searxng.env".path;
        settings = {
          outgoing = {
            request_timeout = 2.0;
            pool_connections = 100;
            pool_maxsize = 20;
          };
          server = {
            secret_key = "$SEARXNG_SECRET";
            port = port;
            bind_address = epSelf.bindAddress;
            base_url = epSelf.publicUrl;
            public_instance = false;
          };
          search = {
            safe_search = 0;
            autocomplete = "";
            languages = [
              "en"
              "en-GB"
              "zh-CN"
            ];
            formats = [
              "html"
              "json"
            ];
          };
          hostnames.remove = [
            "(.*\.)?csdn.net$"
            "(.*\.)?cn.nytimes.com$"
            "(.*\.)?gitcode.com$"
          ];
          ui = {
            hotkeys = "vim";
            url_formatting = "pretty";
          };
        };
      };

      services.nginx.virtualHosts = lib.mkIf (url != null) {
        ${url} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:${portStr}";
          };
        }
        // config.nixdefs.consts.nginxWithCF;
      };
    };
}

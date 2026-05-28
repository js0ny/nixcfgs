{
  pkgs,
  lib,
  config,
  secrets,
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
  sops.secrets.searxng_secret = {
    sopsFile = secrets + /searxng.yaml;
  };

  sops.templates."searxng.env".content = /* bash */ ''
    SEARXNG_SECRET=${config.sops.placeholder.searxng_secret}
  '';

  services.searx = {
    enable = true;
    redisCreateLocally = true;
    environmentFile = config.sops.templates."searxng.env".path;
    settings = {
      use_default_settings.engines.keep_only = [
        "google"
        "brave"
        "duckduckgo"
        "github"
        "stackoverflow"
        "reddit"
        "wikipedia"
        "arch linux wiki"
        "nixos wiki"
        "npm"
        "pypi"
        "crates.io"
        "arxiv"
      ];
      engines = [
        {
          name = "google";
          shortcut = "g";
          timeout = 2.5;
          weight = 2.0;
          disabled = false;
        }
        {
          name = "brave";
          shortcut = "b";
          timeout = 2.0;
          weight = 1.2;
          disabled = false;
        }
        {
          name = "duckduckgo";
          shortcut = "ddg";
          timeout = 1.8;
          disabled = false;
        }
        {
          name = "github";
          shortcut = "gh";
          timeout = 2.0;
          disabled = false;
        }
        {
          name = "stackoverflow";
          shortcut = "so";
          timeout = 2.0;
          disabled = false;
        }
        {
          name = "reddit";
          shortcut = "r";
          timeout = 2.5;
          disabled = false;
        }
        {
          name = "arch linux wiki";
          shortcut = "aw";
          disabled = false;
        }
        {
          name = "nixos wiki";
          shortcut = "nw";
          disabled = false;
        }
        {
          name = "npm";
          disabled = false;
        }
        {
          name = "crates.io";
          disabled = false;
        }
        {
          name = "nixpkgs";
          engine = "command";
          shortcut = "np";
          timeout = 1.0;
          command = [
            (lib.getExe pkgs.python3)
            "-c"
            /* python */ ''
              import sys, urllib.parse

              query = " ".join(sys.argv[1:])
              url = "https://search.nixos.org/packages?channel=unstable&query=" + urllib.parse.quote_plus(query)
              print(f"Nixpkgs packages\t{url}\tSearch NixOS packages for {query}")
            ''
            "{{QUERY}}"
          ];
          delimiter = {
            chars = "\t";
            keys = [
              "title"
              "url"
              "content"
            ];
          };
          disabled = false;
        }
      ];
      outgoing = {
        request_timeout = 2.0;
        pool_connections = 100;
        pool_maxsize = 20;
      };
      server = {
        secret_key = "$SEARXNG_SECRET";
        port = port;
        bind_address = "0.0.0.0";
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
    };
  };
}

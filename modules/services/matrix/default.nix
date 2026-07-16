{
  flake.nixosModules.matrix =
    {
      config,
      lib,
      secrets,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      epSelf = ep.matrix;
      domain = "js0ny.net";
      portStr = epSelf.portStr;
      url = epSelf.domain;
      asDir = "/var/lib/tuwunel/appservices";
      rtcFoci = [
        {
          type = "livekit";
          livekit_service_url = "https://${url}/livekit/jwt";
        }
      ];
      clientWellKnown = builtins.toJSON {
        "m.homeserver".base_url = "https://${url}";
        "m.rtc_foci" = rtcFoci;
        "org.matrix.msc4143.rtc_foci" = rtcFoci;
      };
    in
    {
      imports = [
        ./coturn.nix
        ./hookshot.nix
        ./livekit.nix
        ./oidc.nix
      ];
      sops.secrets.matrix_reg_token = {
        sopsFile = secrets + /matrix.yaml;
        owner = config.services.matrix-tuwunel.user;
        group = config.services.matrix-tuwunel.group;
      };

      services.matrix-tuwunel = {
        enable = true;
        # https://matrix-construct.github.io/tuwunel/configuration.html
        settings.global = {
          server_name = domain;
          address = [
            "127.0.0.1"
            "::1"
          ];
          port = [ epSelf.port ];
          allow_registration = true;
          registration_token_file = config.sops.secrets.matrix_reg_token.path;
          allow_federation = false;
          allow_encryption = true;
          max_request_size = 20000000;
          appservice_dir = asDir;
        };
      };

      systemd.services.tuwunel = {
        serviceConfig = {
          DynamicUser = lib.mkForce false;
        };
      };

      nixdots.persist.system = {
        directories = [
          {
            directory = "/var/lib/tuwunel";
            user = "tuwunel";
            group = "tuwunel";
            mode = "0750";
          }
        ];
      };

      systemd.tmpfiles.rules = [
        "d ${asDir} 0700 tuwunel tuwunel -"
      ];

      services.nginx = {
        virtualHosts."${domain}" = (
          {
            forceSSL = true;
            locations."= /.well-known/matrix/server".extraConfig = /* nginx */ ''
              default_type application/json;
              add_header Access-Control-Allow-Origin *;
              return 200 '{"m.server": "${url}:443"}';
            '';
            locations."= /.well-known/matrix/client".extraConfig = /* nginx */ ''
              default_type application/json;
              add_header Access-Control-Allow-Origin *;
              add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS";
              add_header Access-Control-Allow-Headers "X-Requested-With, Content-Type, Authorization";
              return 200 '${clientWellKnown}';
            '';
          }
          // config.nixdefs.consts.nginxWithCF
        );

        virtualHosts."${url}" = (
          {
            forceSSL = true;
            locations."/_matrix".proxyPass = "http://127.0.0.1:${portStr}";
            locations."/_synapse/client".proxyPass = "http://127.0.0.1:${portStr}";
          }
          // config.nixdefs.consts.nginxWithCF
        );
      };
      nixpkgs.config.permittedInsecurePackages = [
        "olm-3.2.16"
      ];
    };
  # Async Media
  # https://github.com/matrix-construct/tuwunel/issues/263
}

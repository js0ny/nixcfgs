{
  flake.nixosModules.authelia =
    {
      config,
      secrets,
      myLib,
      ...
    }:
    let
      sec = config.sops.secrets;
      ep = config.nixdefs.endpoints;
      epSelf = ep.authelia;
      epMetrics = ep.authelia-metrics;
      ip = epSelf.bindAddress;
      portStr = epSelf.portStr;
      url = epSelf.domain;
      publicUrl = epSelf.publicUrl;
      stateDir = "/var/lib/authelia-main";
      domain = "js0ny.net";
    in
    {
      imports = myLib.scanPaths ./.;
      sops.secrets = {
        authelia_jwt_secret = {
          sopsFile = secrets + /authelia.yaml;
          owner = "authelia-main";
        };
        authelia_session_secret = {
          sopsFile = secrets + /authelia.yaml;
          owner = "authelia-main";
        };
        authelia_encryption_key = {
          sopsFile = secrets + /authelia.yaml;
          owner = "authelia-main";
        };
        authelia_oidc_hmac_secret = {
          sopsFile = secrets + /authelia.yaml;
          owner = "authelia-main";
        };
        authelia_oidc_rsa_private_key = {
          sopsFile = secrets + /authelia.yaml;
          owner = "authelia-main";
        };
      };

      services.authelia.instances."main" = {
        enable = true;

        secrets = {
          jwtSecretFile = sec.authelia_jwt_secret.path;
          sessionSecretFile = sec.authelia_session_secret.path;
          storageEncryptionKeyFile = sec.authelia_encryption_key.path;
          oidcHmacSecretFile = sec.authelia_oidc_hmac_secret.path;
          oidcIssuerPrivateKeyFile = sec.authelia_oidc_rsa_private_key.path;
        };

        settings = {
          theme = "auto";
          default_2fa_method = "webauthn";
          server.address = "tcp://${ip}:${portStr}/";
          telemetry.metrics = {
            enabled = true;
            address = "tcp://${epMetrics.bindAddress}:${epMetrics.portStr}/metrics";
          };
          log.level = "info";

          session.cookies = [
            {
              domain = "${domain}";
              authelia_url = publicUrl;
              default_redirection_url = "https://${domain}";
            }
          ];

          notifier = {
            disable_startup_check = true;
            filesystem.filename = "${stateDir}/notification.txt";
          };

          storage.local.path = "${stateDir}/db.sqlite3";

          authentication_backend.file = {
            path = secrets + /authelia-users.yml;
            watch = true;
          };

          identity_providers.oidc = {
            lifespans = {
              access_token = "1h";
              authorize_code = "1m";
              id_token = "1h";
              refresh_token = "90m";
            };
            clients = [
              {
                client_id = "lobechat";
                client_name = "LobeHub";
                client_secret = "$pbkdf2-sha512$310000$GF7/6SshgkJDSITler.lTA$lQ1X/J6aNAF087QwPN95yLBqvBqKfWIDufTC58ngIGEFtc.eeD7Z1wX1AlBLpJT8icEEIxZ1Pl95hTxSqGOrHA";
                redirect_uris = [
                  "${ep.lobechat.publicUrl}/api/auth/callback/authelia"
                ];
                scopes = [
                  "openid"
                  "profile"
                  "email"
                ];
                token_endpoint_auth_method = "client_secret_post";
              }
              {
                client_id = "forgejo";
                client_name = "Forgejo";
                client_secret = "$pbkdf2-sha512$310000$GRDVmKGhKSyhAMvU1KHWzg$n.WB0CTyt.jqmilyca4BZYZxj8hlBQ.ZuWgRLiMB4SV0At1FyIB6/E1iEFXJAZ/c0O1Vo1MMI0pZfqRezMHR6Q";
                public = false;
                authorization_policy = "two_factor";
                scopes = [
                  "openid"
                  "profile"
                  "email"
                  "groups"
                ];
                redirect_uris = [
                  "${ep.forgejo.publicUrl}/user/oauth2/authelia/callback"
                ];
                userinfo_signed_response_alg = "none";
              }
              {
                client_id = "open-webui";
                client_name = "Open WebUI";
                client_secret = "$pbkdf2-sha512$310000$J19VhsdQEVbf/MGnCXe5eQ$XqDMgASKp11oF3UutVpaA7m96LMhSuSem7CrojaJXdoOPpgbaLS1/PTSxB5AsBjByQYRDI28gMCGyDCOsvrSWQ";
                public = false;
                authorization_policy = "two_factor";
                redirect_uris = [
                  "${ep.open-webui.publicUrl}/oauth/oidc/callback"
                ];
                scopes = [
                  "openid"
                  "email"
                  "profile"
                  "groups"
                ];
              }
              {
                client_id = "paperless";
                client_name = "PaperlessNGX";
                client_secret = "$pbkdf2-sha512$310000$0tod0G0O6EHOMzs9ye1s4A$drsEh.xD0vcEf22osciaEwde4ngJyFsP3PwpELr4LWV86gYZj5TLCDcORkdtBe/Q57bDwLPpixzTL6BtiKKqbA";
                public = false;
                authorization_policy = "two_factor";
                redirect_uris = [
                  "${ep.paperless.publicUrl}/accounts/oidc/authelia/login/callback/"
                ];
                scopes = [
                  "openid"
                  "email"
                  "profile"
                  "groups"
                ];
                response_types = [ "code" ];
                grant_types = [ "authorization_code" ];
                access_token_signed_response_alg = "none";
                userinfo_signed_response_alg = "none";
                token_endpoint_auth_method = "client_secret_basic";
              }
              {
                client_id = "librechat";
                client_name = "LibreChat";
                client_secret = "$pbkdf2-sha512$310000$el9K5mX.NE3pZkk4ZGH/RA$RBJ3OAn2dTtsaNBvMVGI.82yPu/qxwvl4XoNE2IU9cMnCSortA0uC1SLZHRTRktFh7Nsy7EvfeicEg/2ND6Jog";
                public = false;
                authorization_policy = "two_factor";
                redirect_uris = [ "${ep.librechat.publicUrl}/oauth/openid/callback" ];
                scopes = [
                  "openid"
                  "profile"
                  "email"
                ];
                userinfo_signed_response_alg = "none";
                token_endpoint_auth_method = "client_secret_post";
              }
              {
                client_id = "miniflux";
                client_name = "Miniflux";
                client_secret = "$pbkdf2-sha512$310000$jP53hdn6hZHFoPcwAwjKyw$Pr459Bi/f6K0HC.BRD0tHFLoacB5X/KuUTVibD1i4tI0I0Zsv7DLMHPxct.hN2BeDR9XIT58Z8N55FA4kcXqpw";
                public = false;
                authorization_policy = "two_factor";
                redirect_uris = [ "${ep.miniflux.publicUrl}/oauth2/oidc/callback" ];
                scopes = [
                  "openid"
                  "profile"
                  "email"
                ];
                token_endpoint_auth_method = "client_secret_post";
              }
              {
                client_id = "karakeep";
                client_name = "Karakeep";
                client_secret = "$pbkdf2-sha512$310000$.mimWXT9.vi0XhZ7BmbvqQ$H1fKslTExGcxp.gfTOzu8uHtUrSEXZDqZm6JZt/Kco4h5bQH1bwRw6pySwPuUb6ZCC5MGAx0Yugwc/vjeGn83w";
                public = false;
                authorization_policy = "two_factor";
                require_pkce = false;
                redirect_uris = [
                  "${ep.karakeep.publicUrl}/api/auth/callback/custom"
                ];
                scopes = [
                  "openid"
                  "email"
                  "profile"
                ];
                response_types = [ "code" ];
                grant_types = [ "authorization_code" ];
                access_token_signed_response_alg = "none";
                userinfo_signed_response_alg = "none";
                token_endpoint_auth_method = "client_secret_basic";
              }
              {
                client_id = "vikunja";
                client_name = "Vikunja";
                client_secret = "$pbkdf2-sha512$310000$zrpUeuzpQGR/j..jJWg/WA$A4CH/Hps1bROOlYN3rvJnNjPVb7Pl3pR6CBREUTjJU6R.Tymk7QAB37d1znWOOto.r3Hua/99.OqmjZA0oRh.g";
                public = false;
                authorization_policy = "two_factor";
                require_pkce = false;
                pkce_challenge_method = "";
                redirect_uris = [
                  "${ep.vikunja.publicUrl}/auth/openid/authelia"
                ];
                scopes = [
                  "openid"
                  "profile"
                  "email"
                ];
                response_types = [
                  "code"
                ];
                grant_types = [
                  "authorization_code"
                ];
                access_token_signed_response_alg = "none";
                userinfo_signed_response_alg = "none";
                token_endpoint_auth_method = "client_secret_basic";
              }
            ];
          };
          access_control = {
            default_policy = "two_factor";
          };
        };
      };

      services.nginx.virtualHosts."${url}" = {
        locations."/" = {
          extraConfig = /* nginx */ ''
            proxy_pass http://127.0.0.1:${portStr};
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Uri $request_uri;
            proxy_set_header X-Forwarded-Ssl on;
          '';
        };
      }
      // config.nixdefs.consts.nginxWithCF;
      nixdots.persist.system.directories = [ stateDir ];
    };
}

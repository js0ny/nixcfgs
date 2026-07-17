{
  flake.nixosModules.lldap =
    {
      config,
      secrets,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      http = ep.lldap-http;
      ldap = ep.lldap-ldap;
    in
    {

      sops.secrets = {
        lldap_admin_password.sopsFile = secrets + /authelia.yaml;
        lldap_jwt_secret.sopsFile = secrets + /authelia.yaml;
        lldap_key_seed.sopsFile = secrets + /authelia.yaml;
      };
      sops.templates."lldap.env".content = /* bash */ ''
        LLDAP_KEY_SEED=${config.sops.placeholder.lldap_key_seed}
      '';

      services.lldap = {
        enable = true;
        database.type = "sqlite";
        environmentFile = config.sops.templates."lldap.env".path;
        environment = {
          LLDAP_JWT_SECRET_FILE = "/run/credentials/lldap.service/jwt-secret";
          LLDAP_LDAP_USER_PASS_FILE = "/run/credentials/lldap.service/admin-password";
        };
        # https://github.com/lldap/lldap/blob/main/lldap_config.docker_template.toml
        settings = {
          ldap_host = ldap.bindAddress;
          ldap_port = ldap.port;
          http_host = http.bindAddress;
          http_port = http.port;
          http_url = http.publicUrl;
          ldap_base_dn = "dc=js0ny,dc=net";
          ldap_user_dn = "admin";
          ldap_user_email = "lldap-admin@internal.js0ny.net";
          force_ldap_user_pass_reset = "always";
          smtp_options.enable_password_reset = false;
        };
      };

      systemd.services.lldap.serviceConfig.LoadCredential = [
        "admin-password:${config.sops.secrets.lldap_admin_password.path}"
        "jwt-secret:${config.sops.secrets.lldap_jwt_secret.path}"
      ];

      services.nginx.virtualHosts.${http.domain} = {
        locations."/".proxyPass = "http://${http.listenStr}";
      }
      // config.nixdefs.consts.nginxWithCF;

      nixdots.persist.system.directories = [ "/var/lib/lldap" ];
    };
}

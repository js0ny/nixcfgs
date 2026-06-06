{
  lib,
  pkgs,
  config,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.grafana;
  epPrometheus = ep.prometheus;
  epAlertmanager = ep.prometheus-alertmanager;
  service = config.systemd.services.grafana;
  url = epSelf.domain;
  openid = config.nixdefs.selfhosted.openid;
  socketPath = "/run/grafana/grafana.sock";
  autheliaDashboard = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/authelia/authelia/master/examples/grafana-dashboards/simple.json";
    hash = "sha256-y+WbEev4ezdJyorjnnZi37CL1Pd9PxYAvl5N0hsFJnk=";
  };
  dashboardDir = pkgs.runCommand "grafana-dashboards" { } /* bash */ ''
    mkdir -p $out
    cp ${autheliaDashboard} $out/authelia.json
  '';
in
{
  sops.secrets =
    let
      sopsFile = secrets + /grafana.yaml;
      owner = service.serviceConfig.User;
    in
    {
      grafana_secret_key = { inherit sopsFile owner; }; # openssl rand -hex 32
      grafana_oidc_secret = { inherit sopsFile owner; }; # openssl rand -hex 32
      grafana_admin_email = { inherit sopsFile owner; };
      grafana_admin_password = { inherit sopsFile owner; };
    };
  services.grafana = {
    enable = true;
    settings = {
      server = {
        protocol = "socket";
        socket = socketPath;
        socket_gid = config.users.groups.${config.services.nginx.group}.gid;
        socket_mode = "0660";
        domain = url;
        root_url = epSelf.publicUrl;
      };
      security = {
        # openssl rand -hex 32
        secret_key = "$__file{${config.sops.secrets.grafana_secret_key.path}}";
        disable_initial_admin_creation = false;
        admin_email = "$__file{${config.sops.secrets.grafana_admin_email.path}}";
        admin_password = "$__file{${config.sops.secrets.grafana_admin_password.path}}";
      };
    }
    // lib.optionalAttrs (openid.enable) {
      auth = {
        disable_login_form = "true";
        oauth_auto_login = "true";
        oauth_allow_insecure_email_lookup = "true";
      };
      "auth.anonymous" = {
        enabled = "false";
      };
      "auth.generic_oauth" = {
        enabled = true;
        name = openid.name;
        icon = "signin";
        client_id = "grafana";
        client_secret = "$__file{${config.sops.secrets.grafana_oidc_secret.path}}";
        scopes = lib.concatStringsSep " " [
          "openid"
          "profile"
          "email"
          "groups"
        ];
        empty_scopes = false;
        auth_url = "${ep.authelia.publicUrl}/api/oidc/authorization";
        token_url = "${ep.authelia.publicUrl}/api/oidc/token";
        api_url = "${ep.authelia.publicUrl}/api/oidc/userinfo";
        login_attribute_path = "preferred_username";
        groups_attribute_path = "groups";
        name_attribute_path = "name";
        use_pkce = true;
        auth_style = "InHeader";
        role_attribute_path = "contains(groups[*], 'admin') && 'GrafanaAdmin' || ''";
        role_attribute_strict = true;
        allow_assign_grafana_admin = true;
      };
    };
    provision = {
      enable = true;
      dashboards.settings = {
        apiVersion = 1;
        providers = [
          {
            name = "Authelia";
            type = "file";
            options.path = dashboardDir;
          }
        ];
      };
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${epPrometheus.portStr}";
          isDefault = true;
        }
        {
          name = "Alertmanager";
          type = "alertmanager";
          access = "proxy";
          url = "http://127.0.0.1:${epAlertmanager.portStr}";
          jsonData.implementation = "prometheus";
        }
      ];
    };
  };
  nixdots.persist.system.directories = [ config.services.grafana.dataDir ];
  systemd.services.grafana.serviceConfig.SupplementaryGroups = [ config.services.nginx.group ];

  services.nginx.virtualHosts = lib.mkIf (url != null) {
    ${url} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://unix:${socketPath}:/";
        proxyWebsockets = true;
      };
    }
    // config.nixdefs.consts.nginxWithCF;
  };
}

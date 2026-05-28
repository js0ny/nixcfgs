{
  config,
  lib,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  domain = "js0ny.net";
  matrixPortStr = ep.matrix.portStr;
  url = ep.matrix.domain;
  portStr = ep.mautrix-telegram.portStr;
  user = "js0ny";
  dname = "js0ny";
  botID = "telegram";
  sopsFile = secrets + /matrix.yaml;
in
{
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  sops.secrets = {
    tg_main_mtproto_id = {
      sopsFile = secrets + /telegram.yaml;
    };
    tg_main_mtproto_hash = {
      sopsFile = secrets + /telegram.yaml;
    };
    mautrix_telegram_secret = { inherit sopsFile; };
    mautrix_telegram_as = { inherit sopsFile; };
    mautrix_telegram_hs = { inherit sopsFile; };
  };

  sops.templates."mautrix-telegram.env".content = /* bash */ ''
    MAUTRIX_TELEGRAM_TELEGRAM_API_ID=${config.sops.placeholder.tg_main_mtproto_id}
    MAUTRIX_TELEGRAM_TELEGRAM_API_HASH=${config.sops.placeholder.tg_main_mtproto_hash}
    MAUTRIX_TELEGRAM_APPSERVICE_AS_TOKEN=${config.sops.placeholder.mautrix_telegram_as}
    MAUTRIX_TELEGRAM_APPSERVICE_HS_TOKEN=${config.sops.placeholder.mautrix_telegram_hs}
  '';

  # [Human Intervention] 需要手动发给 bot 以注册服务
  sops.templates."telegram-registration.yaml" = {
    content = /* yaml */ ''
      id: ${botID}
      as_token: ${config.sops.placeholder.mautrix_telegram_as}
      hs_token: ${config.sops.placeholder.mautrix_telegram_hs}
      namespaces:
          users:
          - exclusive: true
            regex: '@${botID}_.*:${dname}\.net'
          - exclusive: true
            regex: '@${botID}:${dname}\.net'
          aliases:
          - exclusive: true
            regex: \#${botID}_.*:${dname}\.net
      url: http://localhost:${portStr}
      sender_localpart: ${botID}bot
      rate_limited: false
      de.sorunome.msc2409.push_ephemeral: true
      receive_ephemeral: true
    '';
    path = "/var/lib/tuwunel/appservices/telegram-registration.yaml";
    mode = "0600";
    owner = "tuwunel";
    group = "tuwunel";
  };

  nixdots.persist.system.directories = [
    {
      directory = "/var/lib/mautrix-telegram";
      user = "mautrix-telegram";
      mode = "0750";
    }
  ];

  services.mautrix-telegram = {
    enable = true;
    environmentFile = config.sops.templates."mautrix-telegram.env".path;
    settings = {
      homeserver = {
        address = "http://localhost:${matrixPortStr}";
        domain = domain;
      };
      appservice = {
        address = "http://localhost:${portStr}";
        hostname = "0.0.0.0";
        port = ep.mautrix-telegram.port;
        database = "sqlite:////var/lib/mautrix-telegram/mautrix-telegram.db";
        id = "telegram";
        bot_username = "telegram";
      };
      bridge = {
        relaybot.authless_portals = false;
        permissions = {
          "@${user}:${domain}" = "admin";
          "@admin:${domain}" = "admin";
        };
        backfill = {
          enable = false;
          max_initial_messages = -1;
        };
      };
      telegram.connection.use_ipv6 = false;
    };
    serviceDependencies = [ "tuwunel.service" ];
  };

  users.groups."mautrix-telegram" = { };
  users.users.tuwunel.extraGroups = [ "mautrix-telegram" ];
}

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
  portStr = ep.mautrix-telegram.portStr;
  user = "js0ny";
  dname = "js0ny";
  botID = "telegram";
  sopsFile = secrets + /matrix.yaml;
  # [Human Intervention] Disabled until the mautrix-telegram package/module is updated and the server is rebuilt.
  enableBridge = false;
in
lib.mkIf enableBridge {
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
    MAUTRIX_TELEGRAM_NETWORK_API_ID=${config.sops.placeholder.tg_main_mtproto_id}
    MAUTRIX_TELEGRAM_NETWORK_API_HASH=${config.sops.placeholder.tg_main_mtproto_hash}
    MAUTRIX_TELEGRAM_APPSERVICE_AS_TOKEN=${config.sops.placeholder.mautrix_telegram_as}
    MAUTRIX_TELEGRAM_APPSERVICE_HS_TOKEN=${config.sops.placeholder.mautrix_telegram_hs}
  '';

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
            regex: '@${botID}bot:${dname}\.net'
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
    # https://docs.mau.fi/configs/mautrix-telegram/latest
    settings = {
      network = {
        api_id = "$MAUTRIX_TELEGRAM_NETWORK_API_ID";
        api_hash = "$MAUTRIX_TELEGRAM_NETWORK_API_HASH";
        sync = {
          update_limit = 1;
          create_limit = 1;
          login_sync_limit = 1;
          direct_chats = false;
        };
        takeout = {
          dialog_sync = false;
          forward_backfill = false;
          backward_backfill = false;
        };
        connection.use_ipv6 = false;
      };
      homeserver = {
        address = "http://localhost:${matrixPortStr}";
        domain = domain;
        software = "standard";
      };
      appservice = {
        address = "http://localhost:${portStr}";
        hostname = "0.0.0.0";
        port = ep.mautrix-telegram.port;
        database = {
          type = "sqlite3-fk-wal";
          uri = "/var/lib/mautrix-telegram/mautrix-telegram.db";
        };
        id = "telegram";
        bot.username = "telegrambot";
        as_token = "$MAUTRIX_TELEGRAM_APPSERVICE_AS_TOKEN";
        hs_token = "$MAUTRIX_TELEGRAM_APPSERVICE_HS_TOKEN";
      };
      bridge = {
        relay.authless_portals = false;
        backfill = {
          enabled = false;
          max_initial_messages = 0;
          max_catchup_messages = 0;
          queue.enabled = false;
        };
        permissions = {
          "@${user}:${domain}" = "admin";
          "@admin:${domain}" = "admin";
        };
      };
      matrix = {
        federate_rooms = false;
      };
      encryption = {
        allow = true;
        default = false;
        require = false;
      };
    };
    serviceDependencies = [ "tuwunel.service" ];
  };

  users.groups."mautrix-telegram" = { };
  users.users.tuwunel.extraGroups = [ "mautrix-telegram" ];
}

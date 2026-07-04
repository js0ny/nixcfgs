{
  config,
  lib,
  pkgs,
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
  stateDirName = "mautrix-telegram";
  stateDir = "/var/lib/${stateDirName}";
  package = pkgs.nur.repos.moraxyc.mautrix-telegram;
  sopsFile = secrets + /matrix.yaml;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "mautrix-telegram.yaml" {
    env_config_prefix = "MAUTRIX_TELEGRAM_";
    network = {
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
      id = botID;
      bot.username = "${botID}bot";
      ephemeral_events = true;
    };
    database = {
      type = "sqlite3-fk-wal";
      uri = "file:${stateDir}/mautrix-telegram.db?_txlock=immediate";
    };
    bridge = {
      relay.enabled = false;
      permissions = {
        "@${user}:${domain}" = "admin";
        "@admin:${domain}" = "admin";
      };
    };
    backfill = {
      enabled = false;
      max_initial_messages = 0;
      max_catchup_messages = 0;
      queue.enabled = false;
    };
    matrix.federate_rooms = false;
    encryption = {
      allow = true;
      default = false;
      require = false;
      pickle_key = "env";
    };
    provisioning.shared_secret = "disable";
    logging = {
      min_level = "info";
      writers = [
        {
          type = "stdout";
          format = "pretty-colored";
        }
      ];
    };
  };
in
{
  sops.secrets = {
    tg_main_mtproto_id = {
      sopsFile = secrets + /telegram.yaml;
    };
    tg_main_mtproto_hash = {
      sopsFile = secrets + /telegram.yaml;
    };
    mautrix_telegram_as = { inherit sopsFile; };
    mautrix_telegram_hs = { inherit sopsFile; };
    mautrix_telegram_secret = { inherit sopsFile; };
  };

  sops.templates."mautrix-telegram.env".content = /* bash */ ''
    MAUTRIX_TELEGRAM_NETWORK__API_ID=${config.sops.placeholder.tg_main_mtproto_id}
    MAUTRIX_TELEGRAM_NETWORK__API_HASH=${config.sops.placeholder.tg_main_mtproto_hash}
    MAUTRIX_TELEGRAM_APPSERVICE__AS_TOKEN=${config.sops.placeholder.mautrix_telegram_as}
    MAUTRIX_TELEGRAM_APPSERVICE__HS_TOKEN=${config.sops.placeholder.mautrix_telegram_hs}
    MAUTRIX_TELEGRAM_ENCRYPTION__PICKLE_KEY=${config.sops.placeholder.mautrix_telegram_secret}
  '';

  sops.templates."telegram-registration.yaml" = {
    content = /* yaml */ ''
      id: ${botID}
      as_token: ${config.sops.placeholder.mautrix_telegram_as}
      hs_token: ${config.sops.placeholder.mautrix_telegram_hs}
      namespaces:
          users:
          - exclusive: true
            regex: '^@${botID}bot:${dname}\.net$'
          - exclusive: true
            regex: '^@${botID}_.*:${dname}\.net$'
      url: http://localhost:${portStr}
      sender_localpart: ${botID}appservice
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
      directory = stateDir;
      user = "mautrix-telegram";
      mode = "0750";
    }
  ];

  systemd.services.mautrix-telegram = {
    description = "mautrix-telegram Matrix-Telegram bridge";
    wantedBy = [ "multi-user.target" ];
    wants = [
      "network-online.target"
      "tuwunel.service"
    ];
    after = [
      "network-online.target"
      "tuwunel.service"
    ];
    path = [
      pkgs.ffmpeg-headless
      pkgs.lottieconverter
    ];
    environment.HOME = stateDir;
    serviceConfig = {
      Type = "exec";
      User = "mautrix-telegram";
      Group = "mautrix-telegram";
      WorkingDirectory = stateDir;
      StateDirectory = stateDirName;
      EnvironmentFile = config.sops.templates."mautrix-telegram.env".path;
      ExecStart = "${lib.getExe package} -n -c ${configFile}";
      Restart = "on-failure";
      RestartSec = "30s";
      UMask = "0027";
      ReadWritePaths = [ stateDir ];
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ProtectControlGroups = true;
      RestrictSUIDSGID = true;
      RestrictRealtime = true;
      LockPersonality = true;
      ProtectKernelLogs = true;
      ProtectKernelTunables = true;
      ProtectHostname = true;
      ProtectKernelModules = true;
      ProtectClock = true;
      SystemCallArchitectures = "native";
      SystemCallErrorNumber = "EPERM";
      SystemCallFilter = "@system-service";
    };
  };

  users.groups."mautrix-telegram" = { };
  users.users.mautrix-telegram = {
    isSystemUser = true;
    group = "mautrix-telegram";
    home = stateDir;
    description = "mautrix-telegram bridge user";
  };
  users.users.tuwunel.extraGroups = [ "mautrix-telegram" ];
}

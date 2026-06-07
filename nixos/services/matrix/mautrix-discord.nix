{ config, secrets, ... }:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.mautrix-discord;
  domain = "js0ny.net";
  url = ep.matrix.url;
  port = epSelf.port;
  portStr = epSelf.portStr;
  user = "js0ny";
  botID = "discord";
  dname = "js0ny";
  sopsFile = secrets + /matrix.yaml;
in
{
  sops.secrets = {
    mautrix_discord_as = { inherit sopsFile; };
    mautrix_discord_hs = { inherit sopsFile; };
  };
  sops.templates."mautrix-discord.env".content = /* bash */ ''
    MAUTRIX_DISCORD_APPSERVICE_AS_TOKEN=${config.sops.placeholder.mautrix_discord_as}
    MAUTRIX_DISCORD_APPSERVICE_HS_TOKEN=${config.sops.placeholder.mautrix_discord_hs}
  '';
  sops.templates."discord-registration.yaml" = {
    content = /* yaml */ ''
      id: ${botID}
      as_token: ${config.sops.placeholder.mautrix_discord_as}
      hs_token: ${config.sops.placeholder.mautrix_discord_hs}
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
      receive_ephemeral: true
      de.sorunome.msc2409.push_ephemeral: true
    '';
    path = "/var/lib/tuwunel/appservices/discord-registration.yaml";
    mode = "0600";
    owner = "tuwunel";
    group = "tuwunel";
  };
  services.mautrix-discord = {
    enable = true;
    # NOTE: I don't know why this will not generate a config.yaml
    settings = {
      homeserver = {
        address = url;
        domain = domain;
      };
      appservice = {
        address = "http://localhost:${portStr}";
        hostname = "0.0.0.0";
        port = port;
        database = {
          type = "sqlite3-fk-wal";
          uri = "file:${config.services.mautrix-discord.dataDir}/mautrix-discord.db?_txlock=immediate";
        };
        id = botID;
        bot = {
          username = "${botID}bot";
          displayname = "Discord bridge bot";
          avatar = "mxc://maunium.net/nIdEykemnwdisvHbpxflpDlC";
        };
        ephemeral_events = true;
      };
      bridge.permissions = {
        "${domain}" = "user";
        "@${user}:${domain}" = "admin";
        "@admin:${domain}" = "admin";
      };
    };
    serviceDependencies = [ "tuwunel.service" ];
  };

  nixdots.persist.system = {
    directories = [
      {
        directory = config.services.mautrix-discord.dataDir;
        user = "mautrix-discord";
        mode = "0750";
      }
    ];
  };
  users.groups."mautrix-discord" = { };
  users.users.tuwunel.extraGroups = [ "mautrix-discord" ];
}

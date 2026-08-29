# Matrix Tuwunel

TODO

## Matrix RTC / Element Call

## Mautrix Telegram

The bridge is from NUR since nixpkgs still uses the Python version of the bridge, while upstream has already moved to Go version.

### Login

### Create Room

`!tg create-portal "PORTAL_ID"`

### Manipulating Database

`sqlite3` is assumed as the database format

```nix
  database = {
    type = "sqlite3-fk-wal";
    uri = "file:${stateDir}/mautrix-telegram.db?_txlock=immediate";
  };
```

```bash
$ nix shell p#sqlite-interactive
$ sqlite3 /var/lib/mautrix-telegram/mautrix-telegram.db
sqlite> SELECT id, receiver, mxid, name FROM portal;
# id -> corresponded id from Telegram, for example, `channel:CHANNELID` or `user:USERID`
# receiver -> userid
# mxid -> The matrix room id, if bridged. for example: `!*******:homeserver.net` or NULL
# name -> Displayed name of the matrix room, only presents if mxid != NULL
```

### Writing Filter list

See [#Manipulating Database] to get id in mautrix-telegram

```nix
  bridge = {
    mode = "allow";
    list = lib.uniqueStrings [ "channel:CHANNELID" ];
  };
```

The default value is

```yaml
portal_create_filter:
  mode: deny
  list: []
  always_deny_from_login: []
```

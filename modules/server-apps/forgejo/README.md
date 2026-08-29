# Forgejo

## Setup

### OIDC Provisioning

This module requires human intervention.

```bash
sudo -u forgejo \
  FORGEJO_WORK_DIR=/var/lib/forgejo \
  FORGEJO_CUSTOM=/var/lib/forgejo/custom \
  forgejo admin add-oauth \
    --provider=openidConnect \
    --name=authelia \
    --key=forgejo \
    "--secret=$secret" \
    --auto-discover-url="https://auth.example.com/.well-known/openid-configuration" \
    --scopes="openid profile email groups"
```

Reference to

- [forgejo cli](https://forgejo.org/docs/v15.0/admin/command-line/#admin-auth-add-oauth)
- [authelia](https://www.authelia.com/integration/openid-connect/clients/forgejo/#cli)

## Backup

Assumption: All data are in the same filesystem (e.g. lfs) and sqlite3 is used.

See [./backup.nix](./backup.nix)

## Restore

From [#Backup], the output is `$PWD/forgejo-dump-UNIXEPOCH.tar.zst` (specified tarball format)

```bash
mkdir ./forgejo
tar --zstd -xvf ./forgejo-dump-*.tar.zst \
  -C ./forgejo \
  --no-same-owner \
  --no-same-permissions \
  --delay-directory-restore
```

- `gnutar`
- flags for nix generated files, like `catppuccin.forgejo.enable`

Then copy the output to `/var/lib/forgejo`

```bash
sudo chown -R forgejo:forgejo /var/lib/forgejo
```

## File Icons

Material Icon CSS injection with [forgejo-file-icons](https://github.com/js0ny/forgejo-file-icons)

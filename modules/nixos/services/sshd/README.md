# sshd

## Troubleshoot

### duplicated ports

when duplicated ports is defined in `sshd_config`:

```bash
$ sudo sshd -T | rg '^port '
```

The service will fail to start, prompting: `Bind to port {PORT} on {ADDR} failed: Address already in use.`

A temporary workaround is

```bash
sudo systemctl stop sshd
sudo systemd-run \
  --unit=sshd-emergency \
  --property=Restart=on-failure \
  --property=RestartSec=2 \
  /run/current-system/sw/bin/sshd \
  -D \
  -p ${PORT} \
  -o PidFile=/run/sshd-emergency.pid
```

# sing-box

## Setup

### VLESS

Use `sing-box` to generate the credentials and `sops` to store them in the encrypted secrets input:

```bash
# nix shell nixpkgs#sing-box

sing-box generate uuid
sing-box generate reality-keypair
sing-box generate rand 4 --hex
```

Keep the `PublicKey` from `reality-keypair`; it is not a server secret, but clients need it together with the UUID, short ID, server address, port `8443`, server name `www.apple.com`, and flow `xtls-rprx-vision`.

Before enabling the module:

- Ensure TCP port `8443` is available and allowed by any external firewall or security group.
- Forward TCP `8443` to the server when it is behind NAT.
- Ensure the server can reach `www.apple.com:443` directly. If the Reality handshake target is changed, update both `realityServer` uses in the module through the shared variable.
- Do not commit plaintext secrets or the Reality private key to this repository.

References:

- [VLESS inbound](https://sing-box.sagernet.org/configuration/inbound/vless/)
- [Reality fields](https://sing-box.sagernet.org/configuration/shared/tls/#reality-fields)

## Troubleshoot

### Check Public-Private Key Pair

```python
#!/usr/bin/env -S uv run --script
#
# /// script
# requires-python = ">=3.12"
# dependencies = ["cryptography"]
# ///
import base64

from cryptography.hazmat.primitives.asymmetric.x25519 import X25519PrivateKey
from cryptography.hazmat.primitives.serialization import Encoding, PublicFormat

private_b64 = input("Reality private key: ").strip()

raw = base64.urlsafe_b64decode(private_b64 + "=" * (-len(private_b64) % 4))
private = X25519PrivateKey.from_private_bytes(raw)

public = private.public_key().public_bytes(
    Encoding.Raw,
    PublicFormat.Raw,
)

print("Public key:", base64.urlsafe_b64encode(public).rstrip(b"=").decode())
```

### Client Check

```json
{
  "inbounds": [
    {
      "type": "socks",
      "tag": "socks-in",
      "listen": "127.0.0.1",
      "listen_port": 1080
    }
  ],
  "outbounds": [
    {
      "type": "vless",
      "tag": "vless-out",
      "server": "{{SERVER_PUBLIC_IP}}",
      "server_port": 8443,
      "uuid": "{{UUID}}",
      "flow": "xtls-rprx-vision",
      "tls": {
        "enabled": true,
        "reality": {
          "enabled": true,
          "public_key": "{{PUBLIC_KEY}}",
          "short_id": "{{SHORT_ID}}"
        },
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        }
      }
    }
  ]
}
```

```bash
# Assume config above is located in /tmp/singbox.json
nix shell p#sing-box
sing-box -c /tmp/singbox.json &
curl --proxy socks5h://127.0.0.1:1080 https://ifconfig.me
# Expected: {{SERVER_PUBLIC_IP}}
```

## Hook Hash Calculation

```python
import hashlib
import json

identity = {
    "event_name": "session_start",
    "hooks": [{
        "async": False,
        "command": "bash '/home/js0ny/.config/codex/herdr-agent-state.sh' session",
        "timeout": 10,
        "type": "command",
    }],
}

payload = json.dumps(identity, sort_keys=True, separators=(",", ":"), ensure_ascii=False)
print("sha256:" + hashlib.sha256(payload.encode("utf-8")).hexdigest())
```

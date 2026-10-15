#!/bin/sh
# Strata's HTTP server (serve/server.py) with the Nix Python environment: arguments are forwarded unchanged (the
# service passes --engine strata --config <run config> --host/--port).
set -eu

share="@shareDir@"
python="@python@"

# libcuda and libnvidia-ml (the server reads free VRAM from NVML) are the driver's, not CUDA redistributables:
# NixOS keeps them here, next to the driver's other libraries.
add_ld_path() {
  [ -d "$1" ] || return 0
  case ":${LD_LIBRARY_PATH:-}:" in
  *":$1:"*) return 0 ;;
  esac
  LD_LIBRARY_PATH="$1${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  export LD_LIBRARY_PATH
}

add_ld_path /run/opengl-driver/lib

exec "$python" "$share/serve/server.py" "$@"

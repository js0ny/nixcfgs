#!/bin/sh
# Strata's own setup, run across a mutable working root: STRATA_ROOT, the current directory by default.
#
# The upstream tree lives read-only in the Nix store, so it is linked into that root - setup.py, tools/, serve/,
# data/, third_party/ and the engine all resolve through the links, while the setup's own writes (the run config,
# the start script, the log) land in the root and survive a system update. setup.py itself is copied rather than
# linked: it finds its root with Path(__file__).resolve().parent, and a link would resolve back into the store.
#
# Everything else is upstream's setup: it may download and prepare a model, but it never builds, downloads or
# pip-installs the engine - those are the Nix package's (see setup-patch.py).
set -eu

share="@shareDir@"
python="@python@"
root="${STRATA_ROOT:-$PWD}"

# NixOS keeps the driver's tools and libraries here: the setup asks nvidia-smi for the cards.
add_path() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
  *":$1:"*) return 0 ;;
  esac
  PATH="$1:$PATH"
}

add_ld_path() {
  [ -d "$1" ] || return 0
  case ":${LD_LIBRARY_PATH:-}:" in
  *":$1:"*) return 0 ;;
  esac
  LD_LIBRARY_PATH="$1${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  export LD_LIBRARY_PATH
}

add_path /run/opengl-driver/bin
add_ld_path /run/opengl-driver/lib

mkdir -p "$root"
for entry in "$share"/*; do
  name="$(basename "$entry")"
  dest="$root/$name"
  if [ "$name" = "setup.py" ]; then
    rm -f "$dest"
    cp "$entry" "$dest"
    continue
  fi
  if [ -L "$dest" ]; then
    rm -f "$dest" # a link from an earlier generation: point it at this one
  elif [ -e "$dest" ]; then
    echo "strata-setup: keeping $dest, which is not the Nix Strata tree" >&2
    continue
  fi
  ln -s "$entry" "$dest"
done

exec "$python" "$root/setup.py" "$@"

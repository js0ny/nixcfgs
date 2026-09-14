usage() {
  echo "js0ny"
  echo "Usage: rime-deploy [--clean]"
  echo "  --clean  Delete the Rime build directory before deployment."
}

if (($# > 1)); then
  usage >&2
  exit 2
fi

case "${1:-}" in
"")
  ;;
--clean)
  rime_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fcitx5/rime"
  echo "Removing $rime_dir/build"
  rm -rf -- "$rime_dir/build"
  ;;
-h | --help)
  usage
  exit 0
  ;;
*)
  usage >&2
  exit 2
  ;;
esac

exec busctl --user call \
  org.fcitx.Fcitx5 \
  /controller \
  org.fcitx.Fcitx.Controller1 \
  SetConfig \
  sv "fcitx://config/addon/rime/deploy" s ""

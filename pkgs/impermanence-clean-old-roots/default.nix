{ pkgs }:

pkgs.writeShellApplication {
  name = "impermanence-clean-old-roots";
  runtimeInputs = with pkgs; [
    btrfs-progs
    coreutils
    fd
  ];
  text = /* bash */ ''
    usage() {
      printf 'Usage: %s [--dry-run] <mountpoint> <changed-after> <changed-before>\n' "$0"
      printf 'Example: %s --dry-run /btrfs_tmp 30d 7d\n' "$0"
    }

    dry_run=false
    if [ "''${1:-}" = "--dry-run" ]; then
      dry_run=true
      shift
    fi

    if [ "$#" -ne 3 ]; then
      usage >&2
      exit 2
    fi

    mountpoint="''${1%/}"
    changed_after="$2"
    changed_before="$3"
    old_roots="$mountpoint/old_roots"

    if [ ! -d "$old_roots" ]; then
      printf 'old_roots directory does not exist: %s\n' "$old_roots" >&2
      exit 1
    fi

    delete_subvolume_recursively() {
      local path="$1"
      local subvolume

      while IFS= read -r subvolume; do
        delete_subvolume_recursively "$mountpoint/$subvolume"
      done < <(btrfs subvolume list -o "$path" | cut -f 9- -d ' ')

      if [ "$dry_run" = true ]; then
        printf 'would delete: %s\n' "$path"
      else
        btrfs subvolume delete "$path"
      fi
    }

    while IFS= read -r -d $'\0' root; do
      delete_subvolume_recursively "$root"
    done < <(
      fd . "$old_roots" \
        --absolute-path \
        --changed-after "$changed_after" \
        --changed-before "$changed_before" \
        --hidden \
        --max-depth 1 \
        --no-ignore \
        --type directory \
        --print0
    )
  '';
}

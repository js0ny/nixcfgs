{ pkgs, ... }: {
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "hmmkbak";
      text = ''
        if (($# != 1)); then
          echo "Make a backup of a file from symlink (in /nix/store)"
          echo "Usage: $0 <file>" >&2
          exit 1
        fi
        if [[ ! -L "$1" ]]; then
          echo "Error: $1 is not a symlink" >&2
          exit 1
        fi
        mv "$1" "$1.bak"
        cp --dereference "$1.bak" "$1"
        chmod 777 "$1"
      '';
    })

    # keep-sorted start
    (ouch.override { enableUnfree = pkgs.stdenv.hostPlatform.isLinux; })
    # aria2
    ddgr
    gopass
    hyperfine
    jq
    just
    localPkgs.rename-zero-pad
    miniserve
    moor
    p7zip
    rar
    rclone
    unar # For Non UTF-8 archives like gbk or sjis
    wget
    zoxide
    # keep-sorted end
  ];
}

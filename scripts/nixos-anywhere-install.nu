def nixos-anywhere-install [
    ip: string
    hostname: string
    temp: string = ""
    --rsa
    --nix-args: list<string> = []
] {
    if (which ssh-keygen | length) == 0 {
        error make {msg: "ssh-keygen not found in PATH"}
    }
    if (which nix | length) == 0 {
        error make {msg: "nix not found in PATH"}
    }
    if $temp == "" {
        mut temp = mktemp -d | str trim
        print $temp
    }
    let persist_dir = $temp | path join "persist"
    let etc_dir = $persist_dir | path join "etc"
    let key_dir = $etc_dir | path join "ssh"
    let target = $"root@($ip)"
    let flake = $".#($hostname)"
    let comment = $"root@($hostname)"
    let ed25519_key = $temp | path join "ssh_host_ed25519_key"
    let rsa_key = $temp | path join "ssh_host_rsa_key"
    mkdir $key_dir
    chmod 755 $persist_dir
    chmod 755 $etc_dir
    chmod 755 $key_dir
    ^ssh-keygen -q -t ed25519 -N "" -f $ed25519_key -C $comment
    cp $ed25519_key ($key_dir | path join "ssh_host_ed25519_key")
    cp $"($ed25519_key).pub" ($key_dir | path join "ssh_host_ed25519_key.pub")
    chmod 600 ($key_dir | path join "ssh_host_ed25519_key")
    chmod 644 ($key_dir | path join "ssh_host_ed25519_key.pub")
    if $rsa {
        ^ssh-keygen -q -t rsa -b 4096 -N "" -f $rsa_key -C $comment
        cp $rsa_key ($key_dir | path join "ssh_host_rsa_key")
        cp $"($rsa_key).pub" ($key_dir | path join "ssh_host_rsa_key.pub")
        chmod 600 ($key_dir | path join "ssh_host_rsa_key")
        chmod 644 ($key_dir | path join "ssh_host_rsa_key.pub")
    }
    let nix_cmd = [
        run
        ...$nix_args
        github:nix-community/nixos-anywhere
        --
        --flake
        $flake
        --extra-files
        $temp
        $target
    ]
    print "Press (x) to start installation"
    let key = (input listen --types [key])
    if $key.code == "x" {
        ^nix ...$nix_cmd
    } else {
        print "Installation cancelled"
    }
}

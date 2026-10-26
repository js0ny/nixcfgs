#!/usr/bin/env nu

# Keep runtime identity reproducible until upstream fixes flake version stamping:
# https://github.com/NousResearch/hermes-agent/issues/144616

def --wrapped git-output [repository: path, ...args: string] {
    let result = (^git -C $repository ...$args | complete)
    if $result.exit_code != 0 {
        error make {msg: $result.stderr}
    }
    $result.stdout | str trim
}

def main [--repository: path, --lock: path = flake.lock, --output: path = _sources/hermes-agent.json] {
    let lock_data = open --raw $lock | from json
    let node = $lock_data | get ([nodes $lock_data.root inputs hermes-agent] | into cell-path)
    let locked = $lock_data | get ([nodes $node locked] | into cell-path)
    if $locked.type != github or $locked.owner != NousResearch or $locked.repo != hermes-agent {
        error make {msg: "Expected the NousResearch/hermes-agent GitHub input"}
    }

    let repo = if $repository != null {
        $repository | path expand
    } else {
        let cache_home = $env.XDG_CACHE_HOME? | default $nu.cache-dir
        let cache = $cache_home | path join nixcfgs hermes-agent.git
        if not ($cache | path exists) {
            mkdir ($cache | path dirname)
            let result = (^git init --bare $cache | complete)
            if $result.exit_code != 0 {
                error make {msg: $result.stderr}
            }
            (git-output
                $cache
                remote
                add
                origin
                $"https://github.com/($locked.owner)/($locked.repo).git"
            ) | ignore
        }
        print $"Fetching Hermes history for ($locked.rev)..."
        (git-output
            $cache
            fetch
            --filter=blob:none
            --force
            --prune
            --no-tags
            origin
            $locked.rev
            '+refs/tags/v*:refs/tags/v*'
        ) | ignore
        $cache
    }

    let tags = (git-output $repo tag --list --merged $locked.rev
        | lines
        | where {|tag| $tag =~ '^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$' })
    if ($tags | is-empty) {
        error make {
            msg: "No stable release tag is reachable from the locked Hermes revision"
        }
    }
    let matches = $tags | each {|tag| [--match $tag] } | flatten
    let description = (git-output
        $repo
        describe
        --tags
        --long
        --abbrev=40
        $"--candidates=($tags | length)"
        ...$matches
        $locked.rev
    )
    let parsed = ($description
        | parse --regex '^v(?<version>[0-9]+\.[0-9]+\.[0-9]+)-(?<distance>[0-9]+)-g(?<rev>[a-f0-9]{40})$')
    if ($parsed | length) != 1 {
        error make {msg: $"Unexpected Hermes version description: ($description)"}
    }
    let identity = $parsed | first
    if $identity.rev != $locked.rev {
        error make {msg: "Described Hermes revision differs from flake.lock"}
    }
    let metadata = {
        rev: $locked.rev
        version: $identity.version
        distance: ($identity.distance | into int)
    }

    let directory = $output | path expand | path dirname
    mkdir $directory
    let temporary = mktemp --tmpdir-path $directory 'hermes-agent.XXXXXXXX'
    try {
        $"($metadata | to json --indent 2)\n" | save --raw --force $temporary
        mv --force $temporary $output
    } catch {|err|
        rm --force $temporary
        error make {msg: $err.msg}
    }
    print $"Updated ($output): ($description)"
}

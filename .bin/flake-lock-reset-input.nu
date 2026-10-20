#!/usr/bin/env nu

# Restore an input's pin from this repository's HEAD without changing other inputs.
def main [input: string] {
    let head = (^git show HEAD:./flake.lock | complete)
    if $head.exit_code != 0 {
        error make {msg: $head.stderr}
    }
    let previous = $head.stdout | from json
    let current = open --raw flake.lock | from json
    let previous_node = $previous | get ([nodes $previous.root inputs $input] | into cell-path)
    let current_node = $current | get ([nodes $current.root inputs $input] | into cell-path)
    if ($previous_node | describe) != "string" or ($current_node | describe) != "string" {
        error make {msg: "Cannot reset a following input"}
    }
    let locked = $previous | get ([nodes $previous_node locked] | into cell-path)
    let restored = ($current
    | update ([nodes $current_node locked] | into cell-path) $locked
    | to json --indent 2)
    let temporary = (mktemp flake.lock.XXXXXXXX)
    try {
        $"($restored)\n" | save --raw --force $temporary
        mv --force $temporary flake.lock
    } catch {|err|
        rm --force $temporary
        error make {msg: $err.msg}
    }
}

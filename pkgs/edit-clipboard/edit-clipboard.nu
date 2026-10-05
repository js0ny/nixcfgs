#!/usr/bin/env nu

def has-command [name: string] {
    which $name | is-not-empty
}

def notify-error [message: string] {
    if (has-command "notify-send") {
        try {
            ^notify-send --app-name "edit-clipboard" $message | complete | ignore
        } catch {
            null
        }
    }
}

def read-clipboard [kind: string] {
    match $kind {
        "pb" => (^pbpaste | complete)
        "wl" => (^wl-paste | complete)
        "xclip" => (^xclip -selection clipboard -o | complete)
        "xsel" => (^xsel --clipboard --output | complete)
    }
}

def write-clipboard [kind: string, file: string] {
    match $kind {
        "pb" => (open --raw $file | ^pbcopy | complete)
        "wl" => (open --raw $file | ^wl-copy | complete)
        "xclip" => (open --raw $file | ^xclip -selection clipboard -i | complete)
        "xsel" => (open --raw $file | ^xsel --clipboard --input | complete)
    }
}

def main [--editor: string] {
    let editor = $editor | default ($env.EDITOR? | default "vi")
    let clipboard = if (has-command "pbpaste") and (has-command "pbcopy") {
        "pb"
    } else if (has-command "wl-paste") and (has-command "wl-copy") {
        "wl"
    } else if (has-command "xclip") {
        "xclip"
    } else if (has-command "xsel") {
        "xsel"
    } else {
        print -e "Error: No clipboard utility found"
        print -e "Install one of: pbpaste/pbcopy (macOS), wl-clipboard (Wayland), xclip, or xsel (X11)"
        exit 1
    }

    let temp_result = (^mktemp /tmp/clipboard.XXXXXX | complete)
    if $temp_result.exit_code != 0 {
        print -e "Error: Failed to create temporary file"
        exit 1
    }
    let tmpfile = $temp_result.stdout | str trim

    let paste_result = (read-clipboard $clipboard)
    if $paste_result.exit_code != 0 {
        print -e "Error: Failed to read from clipboard"
        notify-error "Error: Failed to read from clipboard"
        rm --force -- $tmpfile
        exit 1
    }
    try {
        $paste_result.stdout | save --force $tmpfile
    } catch {
        print -e "Error: Failed to read from clipboard"
        notify-error "Error: Failed to read from clipboard"
        rm --force -- $tmpfile
        exit 1
    }

    let editor_succeeded = try {
        run-external $editor $tmpfile
        true
    } catch {
        false
    }
    if not $editor_succeeded {
        print -e "Error: Editor exited with error"
        rm --force -- $tmpfile
        exit 1
    }

    let copy_result = try {
        write-clipboard $clipboard $tmpfile
    } catch {
        {exit_code: 1}
    }
    if $copy_result.exit_code != 0 {
        print -e "Error: Failed to write to clipboard"
        rm --force -- $tmpfile
        exit 1
    }

    rm --force -- $tmpfile
}

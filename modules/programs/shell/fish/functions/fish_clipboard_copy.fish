function fish_clipboard_copy
    set -l cmdline
    if isatty stdin
        # Copy the current selection, or the entire commandline if that is empty.
        # Don't use `string collect -N` here - `commandline` adds a newline.
        set cmdline (commandline --current-selection | fish_indent --only-indent | string collect)
        test -n "$cmdline"; or set cmdline (commandline | fish_indent --only-indent | string collect)
        printf '%s' $cmdline | clipboard-copy
    else
        clipboard-copy
    end
end

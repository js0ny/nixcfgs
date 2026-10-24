# terminal-app

Nix helper that creates a terminal application's desktop launcher using
`makeDesktopItem` and installs it with `copyDesktopItems`.

```nix
home.packages = [
  (pkgs.localPkgs.terminal-app {
    name = "btop";
    desktopName = "Btop";
    exec = lib.getExe pkgs.btop;
    icon = "btop";
    xdg-terminal-exec = pkgs.xdg-terminal-exec;
    categories = [
      "System"
      "Monitor"
    ];
  })
];
```

Accepts `makeDesktopItem` arguments. `desktopName` defaults to `name`.
The optional `xdg-terminal-exec` package defaults to `pkgs.xdg-terminal-exec`.
`exec` uses desktop entry command-line syntax, including field codes such as
`%f`; it is prefixed with an absolute store path to `xdg-terminal-exec -e`.
`terminal` is always `false`, since the terminal is launched explicitly.

The output contains only the desktop entry, not a wrapped executable. Use
`lib.getExe` or `lib.getExe'` in `exec` to retain the application's dependency
and avoid relying on `PATH`.

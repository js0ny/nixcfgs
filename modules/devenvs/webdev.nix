{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.webdev;
in
lib.mkIf cfg.enable {
  home.packages =
    with pkgs;
    [
    ]
    ++ lib.optionals cfg.global [
      svelte-language-server
      pnpm_11
      bun
    ];
  programs.zed-editor = {
    extensions = [
      "scss"
      "vue"
      "svelte"
      "xml"
    ];
    userSettings = {
      lsp = {
        package-version-server.binary.path = lib.getExe pkgs.package-version-server;
        tailwindcss-language-server.binary.path = lib.getExe pkgs.tailwindcss-language-server;
        vtsls.binary.path = lib.getExe pkgs.vtsls;
        # eslint.binary.path = lib.getExe pkgs.eslint;
        eslint.binary.path = lib.getExe' pkgs.vscode-langservers-extracted "vscode-eslint-language-server";
        vscode-html-language-server.binary.path = lib.getExe' pkgs.vscode-langservers-extracted "vscode-html-language-server";
        vscode-css-language-server.binary.path = lib.getExe' pkgs.vscode-langservers-extracted "vscode-css-language-server";
        svelte-language-server.binary.path = lib.getExe pkgs.svelte-language-server;
      };
    };
  };
}

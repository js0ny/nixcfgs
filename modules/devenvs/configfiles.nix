{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.configfiles;
  lsp = with pkgs; [
    yaml-language-server
    vscode-json-languageserver
    taplo
  ];
  fmt = with pkgs; [
    yamlfmt
    prettier
    kdlfmt
  ];
in
lib.mkIf cfg.enable {
  home.packages =
    with pkgs;
    [
      yq-go
      jq
    ]
    ++ lib.optionals cfg.global (lsp ++ fmt);
  programs.neovim.extraPackages = (lsp ++ fmt);
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    redhat.vscode-yaml
    tamasfe.even-better-toml
  ];
  programs.vscode.profiles.default.userSettings = {
    "evenBetterToml.taplo.bundled" = false;
    "evenBetterToml.taplo.path" = lib.getExe pkgs.taplo;
  };
  programs.zed-editor.extensions = [
    "json5"
    "jsonl"
    "kdl"
    "toml"
    "terraform"
  ];
}

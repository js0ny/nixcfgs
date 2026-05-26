{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.go;
in
lib.mkIf cfg.enable {
  home.packages = lib.optionals cfg.global (
    with pkgs;
    [
      go
      gopls
    ]
  );
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    golang.go
  ];
}

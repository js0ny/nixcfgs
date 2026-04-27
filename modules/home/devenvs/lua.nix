{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.lua;
in
lib.mkIf cfg.enable {
  home.packages = lib.optionals cfg.global (
    with pkgs;
    [
      lua-language-server
      stylua
    ]
  );
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    sumneko.lua
  ];
  programs.zed-editor.extensions = [ "lua" ];
}

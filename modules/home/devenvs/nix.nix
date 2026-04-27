{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.nix;
in
lib.mkIf cfg.enable {
  home.packages =
    with pkgs;
    [
      nix-diff
      nix-output-monitor
      nvd
    ]
    ++ lib.optionals cfg.global (
      with pkgs;
      [
        nixfmt
        nil
        nixd
      ]
    );
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
  ];
  programs.zed-editor.extensions = [ "nix" ];
}

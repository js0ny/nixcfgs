{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.typst;
in
lib.mkIf cfg.enable {
  home.packages =
    with pkgs;
    [
      corefonts
    ]
    ++ lib.optionals cfg.global [
      typst
      typstyle
      tinymist
    ];
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    myriad-dreamin.tinymist
  ];
  programs.zed-editor.extensions = [ "typst" ];
}

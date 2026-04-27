{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.rust;
in
lib.mkIf cfg.enable {
  home.packages = lib.optionals cfg.global (
    with pkgs;
    [
      rust-analyzer
      rustc
      cargo
      clippy
      rustfmt
      gnumake
      cmake
      llvm
      gcc
    ]
  );
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    rust-lang.rust-analyzer
  ];
}

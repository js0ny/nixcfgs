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
      # keep-sorted start
      cargo
      clippy
      cmake
      gcc
      gnumake
      llvm
      rust-analyzer
      rustc
      rustfmt
      # keep-sorted end
    ]
  );
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    rust-lang.rust-analyzer
  ];
}

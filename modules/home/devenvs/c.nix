{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.c;
in
lib.mkIf cfg.enable {
  home.packages =
    with pkgs;
    [
      (jetbrains.clion.override {
        vmopts = "-Dawt.toolkit.name=WLToolkit";
      })
    ]
    ++ lib.optionals cfg.global [
      gcc
      llvmPackages_21
    ];
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    llvm-vs-code-extensions.vscode-clangd
  ];
  nixdots.programs.shellAliases = lib.mkIf cfg.global {
    "gcc-static" = "nix run nixpkgs#pkgsStatic.gcc";
  };
}

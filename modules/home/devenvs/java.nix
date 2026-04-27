{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.java;
in
lib.mkIf cfg.enable {
  home.packages = [
    (pkgs.jetbrains.idea.override {
      vmopts = "-Dawt.toolkit.name=WLToolkit";
    })
  ]
  ++ lib.optionals cfg.global (
    with pkgs;
    [
      jdt-language-server
      jdk21
    ]
  );
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    redhat.java
    vscjava.vscode-spring-initializr
    vscjava.vscode-java-pack
  ];
  programs.zed-editor = {
    extensions = [ "java" ];
  }
  // lib.optionalAttrs cfg.global {
    extraPackages = with pkgs; [
      jdt-language-server
    ];
  };
}

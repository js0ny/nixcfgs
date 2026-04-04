{pkgs, ...}: {
  # Globally installed development tools
  home.packages = with pkgs; [
    vscode-json-languageserver
    alejandra
    jq
    jujutsu
    github-copilot-cli
    dos2unix
    yq-go
    socat
    httpie
    gron
    jless
    codex
  ];
}

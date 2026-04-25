{ pkgs, ... }:
{
  # Globally installed development tools
  home.packages = with pkgs; [
    vscode-json-languageserver
    nixfmt
    jq
    jujutsu
    github-copilot-cli
    dos2unix
    yq-go
    socat
    httpie
    gron
    jless
    mtr # my-traceroute
    dig
  ];

  programs.zed-editor.extensions = [
    "json5"
    "jsonl"
  ];
}

{ pkgs, ... }:
{
  # Globally installed development tools
  home.packages = with pkgs; [
    # keep-sorted start
    dig
    dos2unix
    github-copilot-cli
    gron
    httpie
    jless
    jq
    jujutsu
    mtr # my-traceroute
    socat
    yq-go
    # keep-sorted end
  ];

  programs.zed-editor.extensions = [
    "json5"
    "jsonl"
  ];
}

{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Globally installed development tools
  home.packages =
    with pkgs;
    [
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
    ]
    ++ lib.optionals (config.nixdefs.mcp.enable) [
      uv
      nodejs_26
    ];

  programs.zed-editor.extensions = [
    "json5"
    "jsonl"
  ];
}

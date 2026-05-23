{ ... }:
{
  imports = [
    # keep-sorted start
    ./librechat.nix
    ./mongodb.nix
    ./ollama.nix
    ./open-webui.nix
    ./opencode-web.nix
    ./syncthing.nix
    ./tailscale.nix
    # keep-sorted end
  ];
}

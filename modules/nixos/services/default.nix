{ ... }:
{
  imports = [
    ./librechat.nix
    ./mongodb.nix
    ./ollama.nix
    ./opencode-web.nix
    ./syncthing.nix
    ./tailscale.nix
  ];
}

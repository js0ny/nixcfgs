{ ... }:
{
  imports = [
    ./librechat.nix
    ./garage.nix
    ./mongodb.nix
    ./ollama.nix
    ./opencode-web.nix
    ./syncthing.nix
    ./tailscale.nix
    ./open-webui.nix
  ];
}

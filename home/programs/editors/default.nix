{ ... }:
{
  imports = [
    ./wakatime.nix
  ];
  nixdefs = {
    lsp.enable = true;
    mcp.enable = true;
  };
}

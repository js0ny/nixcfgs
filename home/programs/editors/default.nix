{ ... }:
{
  imports = [
    ./wakatime.nix
  ];
  nixdefs = {
    lsp.enable = true;
    mcp.enable = true;
  };
  nixdots.persist.home.directories = [ ".config/github-copilot" ];
}

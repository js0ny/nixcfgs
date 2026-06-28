{
  flake.homeModules.editors =
    { config, ... }:
    {
      nixdefs = {
        lsp.enable = true;
        mcp.enable = true;
      };
      nixdots.persist.home.directories = [
        {
          directory = ".config/github-copilot";
          mode = "0700";
        }
      ];
    };
}

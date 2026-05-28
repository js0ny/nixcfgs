{ ... }:
{
  services.litellm = {
    # mcp name cannot contain `-`
    settings.mcp_servers = {
      "deepwiki" = {
        url = "https://mcp.deepwiki.com/mcp";
        description = "Interactively ask on Code Repositories";
      };
      "ghgrep" = {
        url = "https://mcp.grep.app";
        description = "Grep codes on GitHub";
      };
      # "nixos" = {
      #   transport = "stdio";
      #   command = lib.getExe pkgs.mcp-nixos;
      #   args = [ ];
      #   description = "Search nixpkgs, options, home-manager and NixVim";
      # };
      "context7" = {
        server_name = "context7";
        url = "https://mcp.context7.com/mcp";
        static_headers = {
          "CONTEXT7_API_KEY" = "os.environ/CONTEXT7_API_KEY";
        };
        description = "Up-to-date Docs for LLMs and AI code editors";
      };
      # "firecrawl" = {
      #   server_name = "firecrawl";
      #   transport = "stdio";
      #   command = "npx";
      #   args = [
      #     "-y"
      #     "firecrawl-mcp"
      #   ];
      #   env = {
      #     "FIRECRAWL_API_KEY" = "os.environ/FIRECRAWL_API_KEY";
      #   };
      # };
      # "tavily" = {
      #   transport = "stdio";
      #   command = "npx";
      #   args = [
      #     "-y"
      #     "tavily-mcp@latest"
      #   ];
      #   env = {
      #     "TAVILY_API_KEY" = "os.environ/TAVILY_API_KEY";
      #   };
      # };
    };
    environment = {
      # https://docs.litellm.ai/blog/mcp-stdio-command-injection-april-2026
      LITELLM_MCP_STDIO_EXTRA_COMMANDS = "mcp-nixos,nix";

    };
  };
}

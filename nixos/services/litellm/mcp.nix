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
      "nixos" = {
        transport = "stdio";
        command = "uvx";
        args = [ "mcp-nixos" ];
        description = "Search nixpkgs, options, home-manager and NixVim";
      };
      "context7" = {
        server_name = "context7";
        url = "https://mcp.context7.com/mcp";
        static_headers = {
          "CONTEXT7_API_KEY" = "os.environ/CONTEXT7_API_KEY";
        };
        description = "Up-to-date Docs for LLMs and AI code editors";
      };
      "firecrawl" = {
        server_name = "firecrawl";
        url = "os.environ/FIRECRAWL_MCP_URL";
      };
      "tavily" = {
        transport = "stdio";
        command = "npx";
        args = [
          "-y"
          "tavily-mcp@latest"
        ];
        env = {
          "TAVILY_API_KEY" = "os.environ/TAVILY_API_KEY";
        };
      };
    };
  };

}

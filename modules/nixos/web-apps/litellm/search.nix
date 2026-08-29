{
  config,
  ...
}:
let
  selfhosted = config.nixdefs.selfhosted;
  env = envname: "os.environ/${envname}";
in
{
  services.litellm.settings.search_tools = [
    {
      search_tool_name = "searxng-search";
      litellm_params = {
        search_provider = "searxng";
        api_base = selfhosted.searxng.url;
      };
    }
    {
      search_tool_name = "tavily-search";
      litellm_params = {
        search_provider = "tavily";
        api_key = env "TAVILY_API_KEY";
      };
    }
    {
      search_tool_name = "firecrawl-search";
      litellm_params = {
        search_provider = "firecrawl";
        api_key = env "FIRECRAWL_API_KEY";
      };
    }
  ];

}

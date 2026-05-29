let
  env = key: "env.${key}";

  providerMap = {
    deepseek = {
      value = env "DEEPSEEK_API_KEY";
      network_config.base_url = "https://api.deepseek.com";
      custom_provider_config.base_provider_type = "openai";
    };

    openrouter = {
      value = env "OPENROUTER_API_KEY";
    };

    minimax-cn = {
      value = env "MINIMAXCN_API_KEY";
      network_config.base_url = "https://api.minimaxi.com/anthropic";
      custom_provider_config.base_provider_type = "anthropic";
    };

    aihubmix = {
      value = env "AIHUBMIX_API_KEY";
      network_config.base_url = "https://aihubmix.com";
      custom_provider_config.base_provider_type = "openai";
    };

    sub2api-openai = {
      value = env "SUB2API_OPENAI_API_KEY";
      network_config.base_url = "http://127.0.0.1:11070";
      custom_provider_config.base_provider_type = "openai";
    };
  };

  sortUpstream = upstreams: builtins.sort (a: b: (a.order or 999) < (b.order or 999)) upstreams;

  unique =
    values:
    builtins.attrNames (
      builtins.listToAttrs (
        map (value: {
          name = value;
          value = true;
        }) values
      )
    );

  imap0 =
    f: list:
    let
      go =
        index: rest:
        if rest == [ ] then
          [ ]
        else
          [ (f index (builtins.head rest)) ] ++ go (index + 1) (builtins.tail rest);
    in
    go 0 list;

  providerNames =
    models:
    unique (
      builtins.concatLists (
        builtins.attrValues (
          builtins.mapAttrs (_name: model: map (upstream: upstream.provider) model.upstream) models
        )
      )
    );

  providerUpstreams =
    provider: models:
    builtins.concatLists (
      builtins.attrValues (
        builtins.mapAttrs (
          _name: model:
          map (upstream: {
            logical = model.id;
            actual = upstream.model;
          }) (builtins.filter (upstream: upstream.provider == provider) model.upstream)
        ) models
      )
    );

  providerAliases =
    provider: models:
    builtins.listToAttrs (
      map (upstream: {
        name = upstream.logical;
        value = upstream.actual;
      }) (providerUpstreams provider models)
    );

  providerModels = provider: models: builtins.attrNames (providerAliases provider models);

  mkProvider =
    provider: models:
    let
      providerAttrs = builtins.getAttr provider providerMap;
    in
    {
      keys = [
        {
          name = "${provider}-primary";
          value = providerAttrs.value;
          models = providerModels provider models;
          aliases = providerAliases provider models;
          weight = 1.0;
        }
      ];
    }
    // (if providerAttrs ? network_config then { inherit (providerAttrs) network_config; } else { })
    // (
      if providerAttrs ? custom_provider_config then
        { inherit (providerAttrs) custom_provider_config; }
      else
        { }
    );

  mkRoutingRule =
    index: model:
    let
      upstreams = sortUpstream model.upstream;
      primary = builtins.head upstreams;
      fallbacks = builtins.tail upstreams;
    in
    {
      id = "litellm-${model.id}";
      name = "LiteLLM ${model.id}";
      enabled = true;
      cel_expression = ''model == "${model.id}"'';
      targets = [
        {
          provider = primary.provider;
          model = model.id;
          weight = 1.0;
        }
      ];
      fallbacks = map (upstream: "${upstream.provider}/${model.id}") fallbacks;
      scope = "global";
      priority = 10 + index;
    };

  mkBifrostSettings = models: {
    providers =
      builtins.listToAttrs (
        map (provider: {
          name = provider;
          value = mkProvider provider models;
        }) (providerNames models)
      )
      // {
        jina = {
          keys = [
            {
              name = "jina-primary";
              value = env "JINA_AI_API_KEY";
              models = [ "embedding-fast" ];
              aliases."embedding-fast" = "jina-embeddings-v5-omni-nano";
              weight = 1.0;
            }
          ];
          network_config.base_url = "https://api.jina.ai";
          custom_provider_config = {
            base_provider_type = "openai";
            allowed_requests.embedding = true;
          };
        };

        ollama = {
          keys = [
            {
              name = "ollama-local";
              value = "";
              models = [ "embedding-local" ];
              aliases."embedding-local" = "bge-m3:latest";
              weight = 1.0;
              ollama_key_config.url = "env.OLLAMA_URL";
            }
          ];
        };
      };

    governance.routing_rules = (imap0 mkRoutingRule (builtins.attrValues models)) ++ [
      {
        id = "litellm-embedding-fast";
        name = "LiteLLM embedding-fast";
        enabled = true;
        cel_expression = ''request_type == "embedding" && model == "embedding-fast"'';
        targets = [
          {
            provider = "jina";
            model = "embedding-fast";
            weight = 1.0;
          }
        ];
        fallbacks = [ ];
        scope = "global";
        priority = 1000;
      }
      {
        id = "litellm-embedding-local";
        name = "LiteLLM embedding-local";
        enabled = true;
        cel_expression = ''request_type == "embedding" && model == "embedding-local"'';
        targets = [
          {
            provider = "ollama";
            model = "embedding-local";
            weight = 1.0;
          }
        ];
        fallbacks = [ ];
        scope = "global";
        priority = 1001;
      }
    ];
  };
in
{
  inherit mkBifrostSettings;
}

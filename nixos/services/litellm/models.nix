# Data Sources
# models.dev/api.json | openrouter.ai/v1/models
let
  mdevs = builtins.fromJSON (builtins.readFile ../../../_sources/models.json);
  orlist = builtins.fromJSON (builtins.readFile ../../../_sources/openrouter.json);
  ormap = builtins.listToAttrs (
    map (x: {
      name = x.id;
      value = x;
    }) orlist.data
  );
in
{
  "deepseek-v4-pro" =
    let
      orbase = ormap."deepseek/deepseek-v4-pro";
    in
    {
      id = "deepseek-v4-pro";
      label = "DeepSeek V4 Pro";
      kind = "chat";
      upstream = [
        {
          provider = "deepseek";
          model = "deepseek-v4-pro";
          order = 1;
        }
        {
          provider = "aihubmix";
          model = "deepseek-v4-pro";
          order = 2;
        }
        {
          provider = "openrouter";
          model = "deepseek/deepseek-v4-pro";
          order = 3;
        }
      ];
      info = {
        open_weights = true;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = orbase.pricing.input_cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = orbase.top_provider.context_length;
        # (*) limit.output | top_provider.max_completion_tokens
        output = orbase.top_provider.max_completion_tokens;
      };
      capabilities = {
        # .attachment
        attachment = false;
        # .tool_call -> fc
        tools = true;
        # .reasoning
        reasoning = true;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/deepseek-color.webp?raw=true";
      };
    };
  "deepseek-v4-flash" =
    let
      orbase = ormap."deepseek/deepseek-v4-pro";
    in
    {
      id = "deepseek-v4-flash";
      label = "DeepSeek V4 Flash";
      kind = "chat";
      upstream = [
        {
          provider = "deepseek";
          model = "deepseek-v4-flash";
          order = 1;
        }
        {
          provider = "aihubmix";
          model = "deepseek-v4-flash";
          order = 2;
        }
        {
          provider = "openrouter";
          model = "deepseek/deepseek-v4-flash";
          order = 3;
        }
      ];
      info = {
        open_weights = true;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = orbase.pricing.input_cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = orbase.top_provider.context_length;
        # (*) limit.output | top_provider.max_completion_tokens
        output = orbase.top_provider.max_completion_tokens;
      };
      capabilities = {
        # .attachment
        attachment = false;
        # .tool_call -> fc
        tools = true;
        # .reasoning
        reasoning = true;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/deepseek-color.webp?raw=true";
      };
    };
  "MiniMax-M2.7" =
    let
      ormodel = "minimax/minimax-m2.7";
      orbase = ormap."${ormodel}";
      mdev = mdevs.minimax-cn.models."MiniMax-M2.7";
    in
    {
      id = mdev.id;
      label = mdev.name;
      kind = "chat";
      upstream = [
        {
          provider = "minimax-cn";
          model = mdev.id;
          order = 1;
        }
        {
          provider = "openrouter";
          model = ormodel;
          order = 2;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = mdev.cost.cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/minimax-color.webp?raw=true";
      };
    };
  "gpt-5.5" =
    let
      ormodel = "openai/gpt-5.5";
      orbase = ormap."${ormodel}";
      mdev = mdevs.openai.models."gpt-5.5";
    in
    {
      id = mdev.id;
      label = mdev.name;
      kind = "chat";
      upstream = [
        {
          provider = "aihubmix";
          model = "gpt-5.5";
          order = 1;
        }
        {
          provider = "openrouter";
          model = ormodel;
          order = 2;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = orbase.pricing.input_cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/openai.webp?raw=true";
      };
    };
  "gpt-5.5-codex" =
    let
      ormodel = "openai/gpt-5.5";
      orbase = ormap."${ormodel}";
      mdev = mdevs.openai.models."gpt-5.5";
    in
    {
      id = "gpt-5.5-codex";
      label = "GPT 5.5 Codex";
      kind = "chat";
      upstream = [
        {
          provider = "sub2api-openai";
          model = "gpt-5.5";
          order = 1;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = orbase.pricing.input_cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/codex.webp?raw=true";
      };
    };
  "gpt-5.4-codex" =
    let
      ormodel = "openai/gpt-5.4";
      orbase = ormap."${ormodel}";
      mdev = mdevs.openai.models."gpt-5.5";
    in
    {
      id = "gpt-5.4-codex";
      label = "GPT 5.4 Codex";
      kind = "chat";
      upstream = [
        {
          provider = "sub2api-openai";
          model = "gpt-5.4";
          order = 1;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = orbase.pricing.input_cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/codex.webp?raw=true";
      };
    };
  "gpt-5.4" =
    let
      ormodel = "openai/gpt-5.4";
      orbase = ormap."${ormodel}";
      mdev = mdevs.openai.models."gpt-5.4";
    in
    {
      id = mdev.id;
      label = mdev.name;
      kind = "chat";
      upstream = [
        {
          provider = "aihubmix";
          model = "gpt-5.4";
          order = 1;
        }
        {
          provider = "openrouter";
          model = ormodel;
          order = 2;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = orbase.pricing.input_cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/openai.webp?raw=true";
      };
    };
  "kimi-k2.6" =
    let
      ormodel = "moonshotai/kimi-k2.6";
      orbase = ormap."${ormodel}";
      mdev = mdevs."moonshotai-cn".models."kimi-k2.6";
    in
    {
      id = mdev.id;
      label = mdev.name;
      kind = "chat";
      upstream = [
        {
          provider = "openrouter";
          model = ormodel;
          order = 2;
        }
        {
          provider = "aihubmix";
          model = "kimi-k2.6";
          order = 1;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = orbase.pricing.input_cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/moonshot.webp?raw=true";
      };
    };
  "claude-opus-4.8" =
    let
      ormodel = "anthropic/claude-opus-4.8";
      orbase = ormap."${ormodel}";
      mdev = mdevs."anthropic".models."claude-opus-4-8";
    in
    {
      id = mdev.id;
      label = mdev.name;
      kind = "chat";
      upstream = [
        {
          provider = "aihubmix";
          model = "claude-opus-4.8";
          order = 1;
        }
        {
          provider = "openrouter";
          model = ormodel;
          order = 2;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = orbase.pricing.input_cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/claude-color.webp?raw=true";
      };
    };
  "claude-sonnet-4.6" =
    let
      ormodel = "anthropic/claude-sonnet-4.6";
      orbase = ormap."${ormodel}";
      mdev = mdevs."anthropic".models."claude-sonnet-4-6";
    in
    {
      id = mdev.id;
      label = mdev.name;
      kind = "chat";
      upstream = [
        {
          provider = "aihubmix";
          model = "claude-sonnet-4.6-think";
          order = 1;
        }
        {
          provider = "openrouter";
          model = ormodel;
          order = 2;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = orbase.pricing.input_cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/claude-color.webp?raw=true";
      };
    };
  "gemini-3.1-pro-preview" =
    let
      ormodel = "google/gemini-3.1-pro-preview";
      orbase = ormap."${ormodel}";
      mdev = mdevs."google".models."gemini-3.1-pro-preview";
    in
    {
      id = mdev.id;
      label = mdev.name;
      kind = "chat";
      upstream = [
        {
          provider = "aihubmix";
          model = "gemini-3.1-pro-preview";
          order = 1;
        }
        {
          provider = "openrouter";
          model = ormodel;
          order = 2;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = orbase.pricing.input_cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/gemini-color.webp?raw=true";
      };
    };
  "gemini-3.5-flash" =
    let
      ormodel = "google/gemini-3.5-flash";
      orbase = ormap."${ormodel}";
      mdev = mdevs."google".models."gemini-3.5-flash";
    in
    {
      id = mdev.id;
      label = mdev.name;
      kind = "chat";
      upstream = [
        {
          provider = "aihubmix";
          model = "gemini-3.5-flash";
          order = 1;
        }
        {
          provider = "openrouter";
          model = ormodel;
          order = 2;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = orbase.pricing.prompt;
        # cost.output | pricing.completion
        output = orbase.pricing.completion;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = orbase.pricing.input_cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/gemini-color.webp?raw=true";
      };
    };
  "glm-5.1" =
    let
      ormodel = "z-ai/glm-5.1";
      orbase = ormap."${ormodel}";
      mdev = mdevs."zai".models."glm-5.1";
    in
    {
      id = mdev.id;
      label = mdev.name;
      kind = "chat";
      upstream = [
        {
          provider = "openrouter";
          model = ormodel;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = mdev.cost.input;
        # cost.output | pricing.completion
        output = mdev.cost.output;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = mdev.cost.cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/zhipu-color.webp?raw=true";
      };
    };
  "qwen3.7-max" =
    let
      ormodel = "qwen/qwen3.7-max";
      orbase = ormap."${ormodel}";
      mdev = mdevs."alibaba-cn".models."qwen3.7-max";
    in
    {
      id = mdev.id;
      label = mdev.name;
      kind = "chat";
      upstream = [
        {
          provider = "openrouter";
          model = ormodel;
          order = 2;
        }
        {
          provider = "aihubmix";
          model = "qwen3.7-max";
          order = 1;
        }
      ];
      info = {
        open_weights = mdev.open_weights;
      };
      pricing = {
        # cost.input | pricing.prompt
        input = mdev.cost.input;
        # cost.output | pricing.completion
        output = mdev.cost.output;
        # cost.cache_read | pricing.input_cache_read
        cacheRead = mdev.cost.cache_read;
      };
      limit = {
        # (*) limit.context | top_provider.context_length
        context = mdev.limit.context;
        # (*) limit.output | top_provider.max_completion_tokens
        output = mdev.limit.output;
      };
      capabilities = {
        # .attachment
        attachment = mdev.attachment;
        # .tool_call -> fc
        tools = mdev.tool_call;
        # .reasoning
        reasoning = mdev.reasoning;
      };
      clients = {
        icon = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/qwen-color.webp?raw=true";
      };
    };
}

{ ... }:
let
  env = envname: "os.environ/${envname}";
in
{
  services.litellm.settings.model_list = [
    #
    # Primary embedding model
    # Default choice for:
    # - RAG
    # - PKM
    # - semantic search
    # - memory
    #
    {
      model_name = "embedding-fast";

      litellm_params = {
        model = "jina_ai/jina-embeddings-v5-omni-nano";
        api_key = env "JINA_AI_API_KEY";
      };

      model_info = {
        mode = "embedding";
        dimensions = 768;
        multilingual = true;
      };
    }

    #
    # Local fallback / offline embedding
    #
    # IMPORTANT:
    # Do NOT mix vectors from this model
    # with embedding-fast in the same collection.
    #
    {
      model_name = "embedding-local";

      litellm_params = {
        model = "ollama/bge-m3:latest";
      };

      model_info = {
        mode = "embedding";
        dimensions = 1024;
        multilingual = true;
        local = true;
      };
    }
  ];
}

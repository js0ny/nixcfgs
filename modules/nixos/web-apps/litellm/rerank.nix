{ ... }:
let
  env = envname: "os.environ/${envname}";
in
{
  services.litellm.settings.model_list = [
    {
      model_name = "rerank-default";

      litellm_params = {
        model = "jina_ai/jina-rerank-v3";
        api_key = env "JINA_AI_API_KEY";
      };

      model_info = {
        mode = "rerank";
        dimension = 256;
      };
    }
  ];
}

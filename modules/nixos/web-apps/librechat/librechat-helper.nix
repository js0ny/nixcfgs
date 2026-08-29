let
  mkLibreChatModelSpecs = model: {
    name = model.id;
    label = model.label;
    iconURL = model.clients.icon;
    preset = {
      endpoint = "LiteLLM";
      model = model.id;
    };
  };
  mkLibreChatModelSpecList = models: map mkLibreChatModelSpecs (builtins.attrValues models);
  models = import ../litellm/models.nix;
in
mkLibreChatModelSpecList models

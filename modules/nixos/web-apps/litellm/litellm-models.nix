let
  helper = import ./helper.nix;
  models = import ./models.nix;
in
helper.mkLiteLLMModelList models

{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdots.sops;
  normalizedSecrets = lib.mapAttrs (_: secret: builtins.removeAttrs secret [ "env" ]) cfg.secrets;
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        sops.secrets = normalizedSecrets;
      }
      (lib.mkIf (cfg.yamlFile != null) {
        sops.defaultSopsFile = cfg.yamlFile;
      })
      (lib.mkIf (cfg.keyFile != null) {
        sops.age = {
          keyFile = cfg.keyFile;
          generateKey = false;
        };
      })
    ]
  );
}

{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.nixdots.sops;
  envSecrets = lib.filterAttrs (_: secret: secret.env != null) cfg.secrets;
  envNames = lib.mapAttrsToList (_: secret: secret.env) envSecrets;
  hasEnvVars = builtins.length envNames > 0;

  secretPaths =
    lib.mapAttrs'
    (secretName: secret: lib.nameValuePair secret.env (lib.getAttr secretName config.sops.secrets).path)
    envSecrets;

  posixInit = builtins.concatStringsSep "\n" (
    lib.mapAttrsToList (name: path: ''
      if [ -r "${path}" ]; then
        export ${name}="$(< "${path}")"
      fi
    '')
    secretPaths
  );

  fishInit = builtins.concatStringsSep "\n" (
    lib.mapAttrsToList (name: path: ''
      if test -r "${path}"
        set -gx "${name}" (cat "${path}")
      end
    '')
    secretPaths
  );
in {
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = builtins.length envNames == builtins.length (lib.unique envNames);
          message = "my.sops.secrets.*.env must be unique.";
        }
      ];

      home.packages = [pkgs.sops];

      nixdots.persist.home = {
        directories = [
          ".config/age"
          ".config/sops/age"
        ];
      };
    }
    (lib.mkIf hasEnvVars {
      programs = {
        zsh.initContent = lib.mkAfter posixInit;
        bash.bashrcExtra = lib.mkAfter posixInit;
        fish.interactiveShellInit = lib.mkAfter fishInit;
      };
    })
    (lib.mkIf (cfg.sopsEditor != null) {
      home.sessionVariables.SOPS_EDITOR = cfg.sopsEditor;
    })
  ]);
}

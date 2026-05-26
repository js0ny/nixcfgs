{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixdots.sops;
  envBindings = builtins.concatMap (
    secretName:
    let
      secret = lib.getAttr secretName cfg.secrets;
      path = (lib.getAttr secretName config.sops.secrets).path;
    in
    builtins.map (name: {
      inherit name path;
    }) secret.env
  ) (builtins.attrNames cfg.secrets);

  envNames = builtins.map (binding: binding.name) envBindings;
  hasEnvVars = builtins.length envNames > 0;

  posixInit = builtins.concatStringsSep "\n" (
    builtins.map (binding: /* bash */ ''
      if [ -r "${binding.path}" ]; then
        export ${binding.name}="$(< "${binding.path}")"
      fi
    '') envBindings
  );

  fishInit = builtins.concatStringsSep "\n" (
    builtins.map (binding: /* fish */ ''
      if test -r "${binding.path}"
        set -gx "${binding.name}" (cat "${binding.path}")
      end
    '') envBindings
  );

  nuInit = builtins.concatStringsSep "\n" (
    builtins.map (binding: /* nu */ ''
      if ( "${binding.path}" | path exists ) {
        $env.${binding.name} = ^cat "${binding.path}"
      }
    '') envBindings
  );
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = builtins.length envNames == builtins.length (lib.unique envNames);
            message = "my.sops.secrets.*.env entries must be unique.";
          }
        ];

        home.packages = [ pkgs.sops ];

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
          nushell.extraConfig = lib.mkAfter nuInit;
        };
      })
      (lib.mkIf (cfg.sopsEditor != null) {
        home.sessionVariables.SOPS_EDITOR = cfg.sopsEditor;
      })
    ]
  );
}

{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixdots.sops;
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ pkgs.sops ];
      }
      (lib.mkIf (cfg.sopsEditor != null) {
        environment.sessionVariables.SOPS_EDITOR = cfg.sopsEditor;
      })
    ]
  );
}

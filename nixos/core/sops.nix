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
      (lib.mkIf (cfg.keyFile != null && !lib.hasPrefix config.nixdots.user.home cfg.keyFile) {
        nixdots.persist.system.files = [ cfg.keyFile ];
      })
    ]
  );
}

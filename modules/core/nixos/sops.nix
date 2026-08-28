{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixdots.sops;
in
lib.mkIf cfg.enable (
  lib.mkMerge [
    {
      environment.systemPackages = [ pkgs.sops ];
    }
    (lib.mkIf (cfg.sopsEditor != null) {
      environment.sessionVariables.SOPS_EDITOR = cfg.sopsEditor;
    })
    (lib.mkIf
      (
        cfg.keyFile != null
        && !lib.hasPrefix config.js0ny.user.home cfg.keyFile
        && !lib.hasPrefix config.nixdots.persist.path cfg.keyFile
        && !lib.hasPrefix config.nixdots.persist.nosnap.path cfg.keyFile
      )
      {
        nixdots.persist.system.files = [ cfg.keyFile ];
      }
    )
  ]
)

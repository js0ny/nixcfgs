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
      environment.systemPackages = with pkgs; [
        sops
        age
      ];
    }
    (lib.mkIf (cfg.sopsEditor != null) {
      environment.sessionVariables.SOPS_EDITOR = cfg.sopsEditor;
    })
    (lib.mkIf (cfg.keyFile != null && !lib.hasPrefix config.js0ny.user.home cfg.keyFile) {
      js0ny.persist.stores.state.files = [
        {
          file = cfg.keyFile;
          how = "symlink";
          mode = "0400";
        }
      ];
    })
  ]
)

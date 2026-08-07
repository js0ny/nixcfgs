{ pkgs, config, ... }:
let
  p = pkgs.js0ny.forgejo-file-icons;
  inherit (config.services.forgejo) customDir user group;
in
{

  systemd.tmpfiles.rules = [
    "d '${customDir}/public' 0750 ${user} ${group} - -"
    "d '${customDir}/public/assets' 0750 ${user} ${group} - -"
    "L+ '${customDir}/public/assets/icons' - - - - ${p}/public/assets/icons"
    "d '${customDir}/templates' 0750 ${user} ${group} - -"
    "d '${customDir}/templates/custom' 0750 ${user} ${group} - -"
    "L+ '${customDir}/templates/custom/header.tmpl' - - - - ${p}/templates/custom/header.tmpl"
  ];

  # Forgejo parses templates once at startup outside dev mode.
  systemd.services.forgejo.restartTriggers = [ p ];
}

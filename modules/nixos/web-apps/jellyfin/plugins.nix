{ lib, pkgs, ... }:
let
  plugins = [
    pkgs.js0ny.jellyfin-plugin-sso-bin
    pkgs.js0ny.jellyfin-plugin-ldapauth-src
  ];
  expandPluginPackage = p: {
    name = p.passthru.pluginName;
    version = p.version;
    path = p;
  };
  pluginManifest = map expandPluginPackage plugins;
  preStartScript = pkgs.writers.writeNuBin "jellyfin-setup-plugins" { } /* nu */ ''
    let m = ${builtins.toJSON pluginManifest}
    for x in $m {
      let target = $"/var/lib/jellyfin/plugins/($x.name)_($x.version)"
      let linkedFiles = (ls $x.path).name | where { |p| ($p | path basename) != "meta.json" }
      mkdir $target
      for f in $linkedFiles {
        let basename = $f | path basename
        let targetPath = $target | path join $basename
        ln -sf $f $target
      }
      let meta = open ($x.path | path join "meta.json") | insert status "Active" | insert autoUpdate false
      let metaTarget = $target | path join "meta.json"
      $meta | to json | save -f ($target | path join "meta.json")
      chmod 660 $metaTarget
    }
  '';
in
{
  systemd.services.jellyfin = {
    serviceConfig.ExecStartPre = lib.getExe preStartScript;
  };
}

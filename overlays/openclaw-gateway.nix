final: prev: {
  openclaw-gateway =
    final.runCommand "openclaw-gateway-fixed" {
      inherit (prev.openclaw-gateway) meta;
      nativeBuildInputs = [final.gnused];
    } ''
      cp -r ${prev.openclaw-gateway} $out
      chmod -R u+w $out
      for ext_dir in $out/lib/openclaw/extensions/*/; do
        ext_name=$(basename "$ext_dir")
        manifest="$ext_dir/openclaw.plugin.json"
        dist_dir="$out/lib/openclaw/dist/extensions/$ext_name"
        if [ -f "$manifest" ] && [ -d "$dist_dir" ]; then
          cp "$manifest" "$dist_dir/"
        fi
      done
      for wrapper in $out/bin/*; do
        if [ -f "$wrapper" ]; then
          sed -i "s|${prev.openclaw-gateway}|$out|g" "$wrapper"
        fi
      done
    '';
}

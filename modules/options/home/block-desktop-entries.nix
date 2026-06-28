# TODO: Complete refactor required
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.misc.block-desktop-entries;

  blockScript = pkgs.writeShellApplication {
    name = "block-desktop-entries";
    runtimeInputs = [
      pkgs.fd
      pkgs.crudini
      pkgs.desktop-file-utils
      pkgs.coreutils
    ];
    text = ''
      target="''${1:-}"
      method="''${2:-block}"

      if [ -z "$target" ]; then
        echo "Usage: block-desktop-entries <prefix> [method]"
        echo "Example: block-desktop-entries waydroid delete"
        exit 1
      fi

      app_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/applications"

      if [ -d "$app_dir" ]; then
        echo "mergetools: Processing desktop entries starting with '$target' in $app_dir (Method: $method)"

        if [ "$method" = "delete" ]; then
          fd -t f "^$target\..*\.desktop$" "$app_dir" -X rm -f
        else
          fd -t f "^$target\..*\.desktop$" "$app_dir" -X crudini --set {} "Desktop Entry" NoDisplay true
        fi

        update-desktop-database "$app_dir"
      else
        echo "mergetools: Applications directory not found: $app_dir"
      fi
    '';
  };
in
{
  options.misc.block-desktop-entries = {
    prefixes = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of desktop file prefixes to hide (e.g., ['waydroid', 'wine']).";
    };

    desktops = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of desktop file prefixes to hide (e.g., ['waydroid', 'wine']).";
    };

    hideMethod = mkOption {
      type = types.enum [
        "block"
        "delete"
      ];
      default = "block";
      description = "Method to hide desktop entries: 'block' (set NoDisplay=true) or 'delete' (remove the .desktop files).";
    };
  };

  config = mkMerge [
    (mkIf (cfg.prefixes != [ ]) {
      home.packages = [ blockScript ];

      home.activation.blockDesktopEntries = hm.dag.entryAfter [ "writeBoundary" ] /* bash */ ''
        if [ -n "''${VERBOSE_ARG:-}" ]; then
          echo "Running block-desktop-entries for configured prefixes..."
        fi

        ${concatMapStringsSep "\n" (prefix: ''
          ${getExe blockScript} "${prefix}" "${cfg.hideMethod}"
        '') cfg.prefixes}
      '';
    })
    (mkIf (cfg.desktops != [ ]) {
      programs.vicinae = {
        settings = {
          providers."applications".entrypoints = lib.genAttrs cfg.desktops (name: {
            enabled = false;
          });
        };
      };
    })
  ];
}

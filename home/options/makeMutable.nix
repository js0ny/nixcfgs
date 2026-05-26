{ lib, config, ... }:
let
  inherit (lib) mkOption types mkIf;
  home = config.home.homeDirectory;
in
{

  options.makeMutable = mkOption {
    type = types.listOf types.str;
    default = [ ];
    description = "list of generated files that relative to home";
  };
  config = mkIf (config.makeMutable != [ ]) {
    home.activation.makeMutable = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      lib.concatMapStringsSep "\n" (file: /* bash */ ''
        if [ -L "${home}/${file}" ]; then
          _dir=$(dirname "${home}/${file}")
          _base=$(basename "${file}")
          mv "${home}/${file}" "$_dir/$_base.nix-managed"
          cp --dereference "$_dir/$_base.nix-managed" "${home}/${file}"
          chmod u+rwx "${home}/${file}"
        fi
      '') config.makeMutable
    );
  };
}

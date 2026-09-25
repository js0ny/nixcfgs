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
    # sops-nix recreates template links during activation, so copy them only afterwards.
    home.activation.makeMutable = lib.hm.dag.entryAfter [ "writeBoundary" "sops-nix" ] (
      lib.concatMapStringsSep "\n" (file: /* bash */ ''
        if [ -L "${home}/${file}" ]; then
          _dir=$(dirname "${home}/${file}")
          _base=$(basename "${file}")
          mv "${home}/${file}" "$_dir/$_base.nix-managed"
          cp --dereference "$_dir/$_base.nix-managed" "${home}/${file}"
          chmod u+rw "${home}/${file}"
        fi
      '') config.makeMutable
    );
  };
}

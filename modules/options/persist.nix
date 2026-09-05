{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption types;

  pathEntryType = types.either types.str types.attrs;
  mountOptionType = types.either types.str types.attrs;

  storeType = types.submodule {
    options = {
      persistentStoragePath = mkOption {
        type = types.path;
        description = "Path at which this store keeps persistent state.";
      };
      directories = mkOption {
        type = types.listOf pathEntryType;
        default = [ ];
        description = "Directories passed directly to Preservation.";
      };
      files = mkOption {
        type = types.listOf pathEntryType;
        default = [ ];
        description = "Files passed directly to Preservation.";
      };
      users = mkOption {
        type = types.attrs;
        default = { };
        description = "User-specific state passed directly to Preservation.";
      };
      commonMountOptions = mkOption {
        type = types.listOf mountOptionType;
        default = [ ];
        description = "Mount options passed directly to Preservation.";
      };
    };
  };
in
{
  options.js0ny.persist = {
    enable = mkEnableOption "persistent state management";

    stores = mkOption {
      type = types.attrsOf storeType;
      default = {
        state.persistentStoragePath = "/persist";
        local.persistentStoragePath = "/nosnap";
      };
      description = "Named persistent stores using Preservation's preserveAt schema.";
    };
  };
}

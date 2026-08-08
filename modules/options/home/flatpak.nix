{ lib, ... }: {
  options.js0ny.flatpak = lib.mkOption {
    type = lib.types.anything;
  };
}

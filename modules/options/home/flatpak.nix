{ lib, ... }: {
  options.js0ny.flatpak = {
    enable = lib.mkEnableOption "enable";
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
    };
  };
}

{
  lib,
  ...
}:
{
  options.nixdots.darwin = {
    enable = lib.mkEnableOption "Whether this is a darwin host";
    homebrew = {
      enable = lib.mkEnableOption "Whether to enable homebrew";
      prefix = lib.mkOption {
        type = lib.types.str;
        default = "/opt/homebrew";
      };
      formulae = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      casks = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      taps = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };
}

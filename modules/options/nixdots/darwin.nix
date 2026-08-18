{
  lib,
  ...
}:
{
  options.nixdots.darwin = {
    enable = lib.mkEnableOption "Whether this is a darwin host";
  };
}

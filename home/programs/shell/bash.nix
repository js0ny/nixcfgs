{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.bash = {
    # only use system bash, prevent from .bashrc generation
    enable = false;
  };
}

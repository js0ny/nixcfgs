{
  pkgs,
  lib,
  config,
  ...
}:
{
  misc.shellAliases = {
    ni = "touch";
    cls = "clear";
    py = "nix run 'nixpkgs#python3'";
  }
  // lib.optionalAttrs (pkgs.stdenv.isDarwin) {
    reboot = "sudo reboot";
    clip = "pbcopy";
    paste = "pbpaste";
    ii = "open";
  }
  // lib.optionalAttrs (config.nixdots.persist.enable) {
    # Hide impermanence mounted directories from duf.
    duf = "duf -hide-mp '/etc/*,/var/*,/home/*/*,/home/*/.*'";
  };
}

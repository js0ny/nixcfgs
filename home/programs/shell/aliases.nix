{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) optionalAttrs;

  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  isNvidia = config.nixdots.machine.nvidia == "nvidia";

  commonAliases = {
    ni = "touch";
    cls = "clear";
    py = "nix run 'nixpkgs#python3'";
    # Hide impermanence mounted directories from duf.
    duf = "duf -hide-mp '/etc/*,/var/*,/home/*/*,/home/*/.*'";
  };

  darwinAliases = {
    reboot = "sudo reboot";
    clip = "pbcopy";
    paste = "pbpaste";
    ii = "open";

    brewi = "brew install";
    brewr = "brew remove";
    brewu = "brew upgrade && brew update";
    brewc = "brew cleanup";
    brewl = "brew list";
  };

  linuxAliases = {
    ii = "xdg-open";
    open = "xdg-open";
  };

  linuxGuiAliases = {
    clip = "wl-copy";
    paste = "wl-paste";
  };

  posixFx = ''
    mt() {
      mkdir -p "$(dirname "$1")" && touch "$1"
    }
    mtv() {
      mkdir -p "$(dirname "$1")" && touch "$1" && $EDITOR "$1"
    }
  '';

  fishFx = ''
    function mt
        mkdir -p (dirname $argv[1]) && touch $argv[1]
    end

    function mtv
        mkdir -p (dirname $argv[1]) && touch $argv[1] && $EDITOR $argv[1]
    end
  '';
in
{
  aliases =
    commonAliases
    // (optionalAttrs isDarwin darwinAliases)
    // (optionalAttrs isLinux (linuxAliases // linuxGuiAliases))
    // (optionalAttrs isNvidia {
      nvidia-settings = ''nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'';
    });

  inherit posixFx fishFx;
}

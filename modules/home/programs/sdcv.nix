{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.sdcv;

  sdcv-fzf = pkgs.writeShellApplication {
    name = "sdcv-fzf";
    runtimeInputs = with pkgs; [fzf sdcv jq];
    text = ''
      fzf --prompt="Dict: " \
          --phony \
          --bind "enter:reload(sdcv {q} -n --json | jq '.[].dict' -r)" \
          --preview "sdcv {q} -en --use-dict={}" \
          --preview-window=wrap \
         < <(echo)
    '';
  };
in {
  options.programs.sdcv = {
    enable = lib.mkEnableOption "sdcv dictionary with fzf frontend";

    dictionaries = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = {};
      description = "Attribute set of dictionary packages to mount. Key is the directory name.";
      example = lib.literalExpression ''
        {
          "langdao-ec" = pkgs.fetchzip { url = "..."; hash = "..."; };
          "local-dict" = pkgs.stdenv.mkDerivation { ... };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.sdcv
      sdcv-fzf
    ];

    xdg.dataFile = lib.mkMerge (
      lib.mapAttrsToList (name: pkg: {
        "stardict/dic/${name}".source = pkg;
      })
      cfg.dictionaries
    );
  };
}

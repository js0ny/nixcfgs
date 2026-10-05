{
  lib,
  config,
  ...
}:
let
  cfg = config.misc.shellAliases;
  nuShellAliases = removeAttrs cfg [
    "ls"
    "ll"
    "la"
    "clip"
  ];
in
{
  options = {
    misc.shellAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Shell aliases shared across Home Manager shells.";
    };
  };

  config = lib.mkIf (cfg != { }) {
    programs.nushell.shellAliases = nuShellAliases;
    programs.zsh.shellAliases = cfg;
    programs.bash.shellAliases = cfg;
    programs.fish.shellAbbrs = cfg;
  };
}

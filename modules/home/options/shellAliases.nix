{
  lib,
  config,
  ...
}:
let
  cfg = config.misc.shellAliases;
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
    programs.nushell.shellAliases = cfg;
    programs.zsh.shellAliases = cfg;
    programs.bash.shellAliases = cfg;
    programs.fish.shellAbbrs = cfg;
  };
}

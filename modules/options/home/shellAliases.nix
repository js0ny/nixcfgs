{
  lib,
  config,
  ...
}:
let
  cfg = config.misc.shellAliases;
  nuabbr = lib.concatMapAttrsStringSep " " (name: value: ''${name}: "${value}"'') cfg;
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
    programs.nushell.extraConfig = /* nu */ ''
      $env.config.abbreviations = { ${nuabbr} }
    '';
    programs.zsh.shellAliases = cfg;
    programs.bash.shellAliases = cfg;
    programs.fish.shellAbbrs = cfg;
  };
}

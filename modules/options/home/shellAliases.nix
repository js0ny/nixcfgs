{
  lib,
  config,
  ...
}:
let
  cfg = config.misc.shellAliases;
  # Remove builtins commands from nushell
  nuAbbr = removeAttrs cfg [
    "ls"
    "ll"
    "la"
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
    programs.nushell.extraConfig = /* nu */ ''
      let misc_aliases = '${builtins.toJSON nuAbbr}' | from json
      $env.config.abbreviations = $env.config.abbreviations | merge  $misc_aliases
    '';
    programs.zsh.shellAliases = cfg;
    programs.bash.shellAliases = cfg;
    programs.fish.shellAbbrs = cfg;
  };
}

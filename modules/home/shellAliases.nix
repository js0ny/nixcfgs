{
  config,
  ...
}: let
  cfg = config.nixdots.programs.shellAliases;
in {
  config = {
    programs.nushell.shellAliases = cfg;
    programs.zsh.shellAliases = cfg;
    programs.bash.shellAliases = cfg;
    programs.fish.shellAbbrs = cfg;
  };
}

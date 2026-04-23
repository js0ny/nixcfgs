{ inputs, config, ... }:
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];
  programs.kate.enable = false;
  programs.kate.editor = {
    font = {
      family = "${config.stylix.fonts.monospace.name}";
      pointSize = 10;
    };
    inputMode = "vi";
  };
}

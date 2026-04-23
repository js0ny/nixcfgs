{ inputs, ... }:
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  programs.okular = {
    enable = true;
    accessibility.changeColors.mode = "InvertLightness";
    general.mouseMode = "TextSelect";
  };
}

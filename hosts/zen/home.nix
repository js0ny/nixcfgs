{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.self.homeModules.darwin
    inputs.self.homeModules.starship
    inputs.self.homeModules.neovim

    # keep-sorted start
    ./vars.nix
    # keep-sorted end

    # keep-sorted start
    inputs.betterfox-nix.modules.homeManager.betterfox
    inputs.catppuccin.homeModules.catppuccin
    inputs.sops-nix.homeManagerModules.sops
    # keep-sorted end

  ];

  targets.darwin.defaults = {
    ".GlobalPreferences" = {
      # Accent Colour: Pink
      "AppleAccentColor" = 6;
      # Folder Colour
      "AppleIconAppearanceTintColor" = "Yellow";
      # Icon & Widget Style
      "AppleInterfaceStyle" = "Dark";
    };
  };

  home.stateVersion = "25.05";

  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = "${config.xdg.configHome}/sops/age/keys.txt";
  };

  home.homeDirectory = lib.mkForce "/Users/js0ny";
}

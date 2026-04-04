{
  config,
  lib,
  ...
}: let
  shell = config.nixdots.apps.interactiveShell.package;
in {
  # Dependency: plasma-manager
  # Required by dolphin's terminal integration
  programs.konsole = {
    enable = true;
    defaultProfile = "Default";
    profiles = {
      Default = {
        command = lib.getExe shell;
        colorScheme = "catppuccin-mocha";
        font = {
          name = "${config.stylix.fonts.monospace.name}";
          size = 12;
        };
        extraConfig = {
          General.Environment = lib.concatStringsSep "," [
            "TERM=xterm-256color"
            "COLORTERM=truecolor"
            "TERM_PROGRAM=konsole"
          ];
        };
      };
    };
  };
}
